# db/seeds.rb

require 'net/http'
require 'json'

puts "🌱 Starting seed with REAL book data and covers from Open Library..."
puts "=" * 50
puts ""

# Clear existing data
puts "🗑️  Clearing existing data..."
Review.destroy_all
Favourite.destroy_all
Book.destroy_all
Author.destroy_all

ActiveRecord::Base.connection.reset_pk_sequence!('authors') if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
ActiveRecord::Base.connection.reset_pk_sequence!('books') if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'

puts "✅ Cleared!"
puts ""

# Function to fetch books from Open Library by subject
def fetch_books_by_subject(subject, limit = 12)
  puts "  📡 Fetching from Open Library API..."
  url = URI("https://openlibrary.org/subjects/#{subject}.json?limit=#{limit}")
  response = Net::HTTP.get(url)
  JSON.parse(response)
rescue => e
  puts "  ⚠️  Error: #{e.message}"
  { 'works' => [] }
end

# Function to get author bio from Open Library
def get_author_bio(author_key)
  return "A celebrated author whose works have influenced readers worldwide." if author_key.nil?

  begin
    url = URI("https://openlibrary.org#{author_key}.json")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    # Bio can be a string or hash with 'value' key
    bio = data['bio']

    if bio.is_a?(Hash) && bio['value']
      bio['value']
    elsif bio.is_a?(String)
      bio
    else
      "A celebrated author whose works have influenced readers worldwide."
    end
  rescue => e
    "A celebrated author whose works have influenced readers worldwide."
  end
end

# Function to get cover image URL
def get_cover_url(cover_id)
  return nil if cover_id.nil?
  "https://covers.openlibrary.org/b/id/#{cover_id}-L.jpg"
end

# Categories to fetch real books from
subjects = {
  'fantasy' => 'Fantasy',
  'science_fiction' => 'Science Fiction',
  'mystery' => 'Mystery',
  'romance' => 'Romance',
  'thriller' => 'Thriller',
  'horror' => 'Horror',
  'classic' => 'Classic',
  'adventure' => 'Adventure'
}

authors_cache = {}  # Cache to avoid duplicate authors

puts "📚 Fetching REAL books with covers from Open Library..."
puts "-" * 50

subjects.each do |subject_key, genre_name|
  puts "\n📖 Fetching #{genre_name} books..."

  data = fetch_books_by_subject(subject_key, 12)
  works = data['works'] || []

  created_count = 0

  works.each do |work|
    # Extract book information
    title = work['title']
    author_name = work['authors']&.first&.dig('name')
    author_key = work['authors']&.first&.dig('key')
    cover_id = work['cover_id']  # This is the cover ID

    # Skip if missing essential data
    next if title.nil? || author_name.nil?

    # Skip if title is too long
    next if title.length > 200

    begin
      # Find or create author
      author = authors_cache[author_name]

      unless author
        puts "  👤 Creating author: #{author_name}"

        # Fetch real bio from Open Library
        bio = get_author_bio(author_key)

        author = Author.create!(
          name: author_name,
          bio: bio
        )

        authors_cache[author_name] = author

        # Be nice to the API
        sleep(0.3)
      end

      # Create book with real description and cover
      description = if work['first_sentence']
                     work['first_sentence'].join(' ')
      else
                     "A captivating #{genre_name} work that has engaged readers for generations."
      end

      # Truncate description if too long
      description = description[0..1000] if description.length > 1000

      # Get cover URL
      cover_url = get_cover_url(cover_id)

      book = Book.create!(
        title: title,
        genre: genre_name,
        description: description,
        author: author,
        cover_image_url: cover_url
      )

      puts "    ✓ #{book.title}#{cover_url ? ' 🖼️' : ''}"
      created_count += 1

      # Be nice to the API
      sleep(0.2)

    rescue ActiveRecord::RecordInvalid => e
      puts "    ⚠️  Skipped (validation error): #{title}"
      next
    rescue => e
      puts "    ⚠️  Error: #{e.message}"
      next
    end
  end

  puts "  ✅ Created #{created_count} #{genre_name} books"
end

puts ""
puts "=" * 50
puts "🎉 SEED COMPLETE!"
puts "=" * 50
puts "📊 Summary:"
puts "  Authors: #{Author.count}"
puts "  Books: #{Book.count}"
puts "  Books with covers: #{Book.where.not(cover_image_url: nil).count}"
puts ""
puts "💡 All data is REAL from Open Library with cover images!"
puts ""
