class Attachment < ApplicationRecord
  mount_uploader :content, ::AttachmentUploader

  belongs_to :user
  belongs_to :create_by, class_name: "User", foreign_key: "create_by"
end
