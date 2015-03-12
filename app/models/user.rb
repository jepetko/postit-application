class User < ActiveRecord::Base

  before_save :generate_slug

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true

  validates :password, presence: true, on: :create, length: {minimum: 3}

  def admin?
    self.role == 'admin'
  end

  def moderator?
    self.role == 'moderator'
  end

  def to_param
    self.slug
  end

  private
  def generate_slug
    self.slug = self.username.gsub(%r{\s+}, '-').downcase
  end
end