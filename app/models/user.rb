class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true

  validates :password, presence: true, on: :create, length: {minimum: 3}

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6))
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def admin?
    self.role == 'admin'
  end

  def moderator?
    self.role == 'moderator'
  end

  def creator?(post)
    self == post.creator
  end

  def has_edit_role?(post)
    admin? || creator?(post)
  end

  def get_slug_value
    self.username
  end


  def send_pin
    twilio_api_hash = PostitTemplate::Application.config.twilio_credentials
    @twilio_client ||= Twilio::REST::Client.new twilio_api_hash['key'], twilio_api_hash['token']
    @twilio_client.account.sms.messages.create(:body => self.pin, :to => self.phone, :from => twilio_api_hash['from'])
  end
end