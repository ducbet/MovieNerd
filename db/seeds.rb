user1 = User.create! name: "TMD",
                     email: "a@a.a",
                     password: "asdasd",
                     user_type: 0

user2 = User.create! name: "Trieu Minh Duc",
                     email: "b@b.b",
                     password: "asdasd",
                     user_type: 0

movie = Movie.create! title: "Wall-E",
  cast: Faker::Name.name + ", " + Faker::Name.name + ", " + Faker::Name.name,
  director: Faker::Name.name,
  description: Faker::Lorem.sentence(10),
  duration: Faker::Number.between(60, 150),
  rated: 0,
  language: "Eng",
  genre: "Animation | Adventure | Family | Sci-Fi"
movie2 = Movie.create! title: "World wall Z",
  cast: Faker::Name.name + ", " + Faker::Name.name + ", " + Faker::Name.name,
  director: Faker::Name.name,
  description: Faker::Lorem.sentence(10),
  duration: Faker::Number.between(60, 150),
  rated: 1,
  language: "Eng",
  genre: "Action | Adventure | Horror | Sci-Fi | Thriller"

1000.times do |n|
  title = Faker::Lorem.sentence 5
    Movie.create! title: "#{n} - #{title}",
    cast: Faker::Name.name + ", " + Faker::Name.name + ", " + Faker::Name.name,
    director: Faker::Name.name,
    description: Faker::Lorem.sentence(10),
    duration: Faker::Number.between(60, 150),
    rated: Faker::Number.between(0, 3),
    language: "Eng",
    genre: "Action | Adventure | Horror | Sci-Fi | Thriller"
end

room = Room.create! name: "G1",
                    seat_no: 50

seat = room.seats.create!

screening = movie.screenings.create! room_id: room.id

order = user1.orders.create! screening_id: screening.id

ticket = order.movie_tickets.create! seat_id: seat.id
