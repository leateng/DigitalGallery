class AddOrderIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :order_id, :string
  end
end
