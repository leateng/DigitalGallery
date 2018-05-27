class AddPasswordTextToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_text, :string
  end
end
