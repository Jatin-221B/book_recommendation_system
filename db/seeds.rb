tolkien = Author.create!(name: "J.R.R. Tolkien", bio: "Fantasy writer")

hobbit = Book.create!(
  title: "The Hobbit",
  description: "A fantasy adventure story...",
  genre: "Fantasy",
  author: tolkien
)

user = User.create!(name: "John Doe", email: "johndoe@example.com")

Review.create!(content: "Loved it!", rating: 5, user: user, book: hobbit)
Favourite.create!(user: user, book: hobbit)
