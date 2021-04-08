User.create!(name:  "安田大樹",
             mail: "yasudaiki0413@gmail.com",
             password: "111111",
             image: "default.jpg",
             admin:true)

    99.times do |n|
      name  = Faker::Name.name
      mail = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(name:  name,
                   mail: mail,
                   password: password,
                   image: "default.jpg")
    end
    
    users = User.order(:created_at).take(6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.posts.create!(content: content) }
    end      
