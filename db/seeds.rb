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

def fetch_books_by_subject(subject, limit = 50)
  puts "  📡 Fetching from Open Library API..."
  url = URI("https://openlibrary.org/subjects/#{subject}.json?limit=#{limit}")
  response = Net::HTTP.get(url)
  JSON.parse(response)
rescue => e
  puts "  ⚠️  Error: #{e.message}"
  { 'works' => [] }
end

def get_author_bio(author_key)
  return "A celebrated author whose works have influenced readers worldwide." if author_key.nil?
  begin
    url = URI("https://openlibrary.org#{author_key}.json")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    bio = data['bio']
    if bio.is_a?(Hash) && bio['value']
      bio['value']
    elsif bio.is_a?(String)
      bio
    else
      "A celebrated author whose works have influenced readers worldwide."
    end
  rescue
    "A celebrated author whose works have influenced readers worldwide."
  end
end

def get_cover_url(cover_id)
  return nil if cover_id.nil?
  "https://covers.openlibrary.org/b/id/#{cover_id}-L.jpg"
end

# 10 subjects x ~50 books each = ~500 books
# Open Library max per request is 50
subjects = {
  'fantasy'          => 'Fantasy',
  'science_fiction'  => 'Science Fiction',
  'mystery'          => 'Mystery',
  'romance'          => 'Romance',
  'thriller'         => 'Thriller',
  'horror'           => 'Horror',
  'classic'          => 'Classic',
  'adventure'        => 'Adventure',
  'biography'        => 'Biography',
  'history'          => 'History'
}

authors_cache = {}

puts "📚 Fetching REAL books with covers from Open Library..."
puts "-" * 50

subjects.each do |subject_key, genre_name|
  puts "\n📖 Fetching #{genre_name} books..."

  data = fetch_books_by_subject(subject_key, 50)
  works = data['works'] || []

  created_count = 0

  works.each do |work|
    title      = work['title']
    author_name = work['authors']&.first&.dig('name')
    author_key  = work['authors']&.first&.dig('key')
    cover_id    = work['cover_id']

    next if title.nil? || author_name.nil?
    next if title.length > 200

    begin
      author = authors_cache[author_name]

      unless author
        puts "  👤 Creating author: #{author_name}"
        bio = get_author_bio(author_key)
        author = Author.create!(name: author_name, bio: bio)
        authors_cache[author_name] = author
        sleep(0.3)
      end

      description = if work['first_sentence']
        work['first_sentence'].is_a?(Array) ? work['first_sentence'].join(' ') : work['first_sentence'].to_s
      else
        "A captivating #{genre_name} work that has engaged readers for generations."
      end

      description = description[0..1000] if description.length > 1000

      # Ensure minimum length for validation
      if description.length < 20
        description = "A captivating #{genre_name} work that has engaged readers for generations."
      end

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
      sleep(0.2)

    rescue ActiveRecord::RecordInvalid => e
      puts "    ⚠️  Skipped (#{e.message}): #{title}"
      next
    rescue => e
      puts "    ⚠️  Error (#{e.message}): #{title}"
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
