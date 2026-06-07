categories = [
  "Транспорт",
  "Недвижимость",
  "Электроника",
  "Работа",
  "Хобби и отдых",
  "Животные",
  "Книги",
  "Для дома"
]

categories.each do |name|
  Category.find_or_create_by!(name: name)
end

users = 5.times.map do |index|
  User.find_or_create_by!(email: "user#{index + 1}@example.com") do |user|
    user.name = "User ##{index + 1}"
  end
end

bulletins_data = [
  [ "Велосипед горный Trek", "Транспорт" ],
  [ "iPhone 13", "Электроника" ],
  [ "Кофемашина", "Для дома" ],
  [ "Учебники английского", "Книги" ],
  [ "Кресло офисное", "Для дома" ],
  [ "Ноутбук Lenovo", "Электроника" ],
  [ "Гитара акустическая", "Хобби и отдых" ],
  [ "Щенок корги", "Животные" ],
  [ "Сдам квартиру", "Недвижимость" ],
  [ "Работа курьером", "Работа" ],
  [ "Самокат Xiaomi", "Транспорт" ],
  [ "Монитор Samsung", "Электроника" ],
  [ "Стол письменный", "Для дома" ],
  [ "Книги по Ruby", "Книги" ],
  [ "Котята в добрые руки", "Животные" ],
  [ "Диван раскладной", "Для дома" ],
  [ "Фотоаппарат Canon", "Электроника" ],
  [ "Сноуборд", "Хобби и отдых" ],
  [ "Гараж в аренду", "Недвижимость" ],
  [ "Вакансия администратора", "Работа" ]
]

image_path = Rails.root.join("app/assets/images/test.png")

puts "Image exists: #{File.exist?(image_path)}"

raise "Seed image not found: #{image_path}" unless File.exist?(image_path)

bulletins_data.each_with_index do |(title, category_name), index|
  bulletin = Bulletin.find_or_initialize_by(title: title)

  states =
    if index < 14
      "published"
    else
      %w[draft under_moderation rejected archived].sample
    end

  bulletin.assign_attributes(
    description: "Демо-описание объявления «#{title}». Это тестовая запись для проверки поиска, фильтрации, состояний и пагинации.",
    category: Category.find_by!(name: category_name),
    user: users.sample,
    state: states
  )
  bulletin.image.purge if bulletin.image.attached?

  bulletin.image.attach(
    io: File.open(image_path),
    filename: "test.png",
    content_type: "image/png"
  )

  bulletin.save!
end

puts "Attachments: #{ActiveStorage::Attachment.count}"
puts "Blobs: #{ActiveStorage::Blob.count}"
