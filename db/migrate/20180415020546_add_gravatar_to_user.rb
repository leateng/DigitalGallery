class AddGravatarToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :gravatar, :string
  end
end
