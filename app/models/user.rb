class User < ApplicationRecord
  has_secure_password
  mount_uploader :gravatar, GravatarUploader

  has_many :attachments, dependent: :destroy

  # 用户级别，管理员， 操作员， 普通用户
  enum role: [:admin, :operator, :user]

  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_TELEPHONE_REGEX = /\A\d{11}\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
            length: { maximum: 255},
            format: { with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password, length: { minimum: 6 }
  validates :telephone, presence: true, format: {with: VALID_TELEPHONE_REGEX}, uniqueness: true, if: Proc.new{|user| user.role == "user"}

  # 普通用户
  scope :clients, ->{where(role: "user")}

  # 返回指定字符串的哈希摘要
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def images
    attachments.select{|a| a.content_type == "jpeg"}
  end

  def videos
    attachments.select{|a| a.content_type == "mp4"}
  end
end
