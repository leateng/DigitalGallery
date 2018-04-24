class AddAppToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :app, :string
  end
end
