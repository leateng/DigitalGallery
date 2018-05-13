class User < ApplicationRecord
  has_secure_password
  attr_accessor :update_profile

  mount_uploader :gravatar, GravatarUploader
  mount_uploader :app, AppUploader

  has_many :attachments, dependent: :destroy

  # 用户级别，管理员， 操作员， 普通用户
  enum role: [:admin, :operator, :client]

  before_create :generate_authentication_token
  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_TELEPHONE_REGEX = /\A\d{11}\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email,
            length: { maximum: 255},
            format: { with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}, if: Proc.new{|user| user.email.present?}
  validates :password, length: { minimum: 6 }, unless: Proc.new{|user| user.update_profile == true}
  validates :telephone,
            presence: true,
            format: {with: VALID_TELEPHONE_REGEX},
            uniqueness: true


  # 管理员
  scope :admins, ->{where(role: "root")}

  # 操作员
  scope :operators, ->{where(role: "operator")}

  # 普通用户
  scope :clients, ->{where(role: "client")}

  # 返回指定字符串的哈希摘要
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 生成用于API认证的token
  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break if !User.find_by(authentication_token: authentication_token)
    end
  end

  def reset_auth_token!
    generate_authentication_token
    save
  end

  def images
    attachments.where(content_type:"jpeg")
  end

  def videos
    attachments.where(content_type:"mp4")
  end

  def targets_json
    h = {}
    h["images"] = []
    self.images.each_with_index do |image, index|
      h["images"] << {"image" => "#{index}.jpg", "name" => "#{index}", "uid" => "#{index}"}
    end

    h
  end
end
