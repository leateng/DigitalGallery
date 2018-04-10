class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string :content
      t.string :content_type
      t.string :meta_info

      t.timestamps
    end
  end
end
