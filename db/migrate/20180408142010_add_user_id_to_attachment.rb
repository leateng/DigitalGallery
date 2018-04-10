class AddUserIdToAttachment < ActiveRecord::Migration[5.1]
  def change
    add_column :attachments, :user_id, :integer
  end
end
