class AddCreateByToAttachment < ActiveRecord::Migration[5.1]
  def change
    add_column :attachments, :creator_id, :integer
  end
end
