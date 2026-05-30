class MakeUserAdmin < ActiveRecord::Migration[7.2]
  def up
    User.find_by(email: 'hyinm2012@yandex.ru')&.update!(admin: true)
  end

  def down
    User.find_by(email: 'hyinm2012@yandex.ru')&.update!(admin: false)
  end
end
