class AddCreateByToAttachment < ActiveRecord::Migration[5.1]
  def change
    add_column :attachments, :create_by, :integer
  end
end
