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

states = %w[draft under_moderation published rejected archived]

image_path = Rails.root.join("app/assets/images/test.png")


bulletins_data.each_with_index do |(title, category_name), index|
  bulletin = Bulletin.find_or_initialize_by(title: title)

  bulletin.assign_attributes(
    description: "Демо-описание объявления «#{title}». Это тестовая запись для проверки поиска, фильтрации, состояний и пагинации.",
    category: Category.find_by!(name: category_name),
    user: users.sample,
    state: states.sample
  )
  unless bulletin.image.attached?
    bulletin.image.attach(
      io: File.open(image_path),
      filename: "test.png",
      content_type: "image/png"
    )
  end

  bulletin.save!
end
