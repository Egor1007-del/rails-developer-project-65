class AddCaseInsensitiveUniqueIndexes < ActiveRecord::Migration[7.2]
  def change
    add_index :users, "lower(email)", unique: true, name: "index_users_on_lower_email"
    add_index :categories, "lower(name)", unique: true, name: "index_categories_on_lower_name"
  end
end
