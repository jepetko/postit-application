class Post < ActiveRecord::Base
  #attr_accessible :title, :url, :description

  belongs_to :creator, :foreign_key => 'user_id', :class_name => 'User'
  has_many :post_categories
  has_many :categories, :through => :post_categories
  has_many :comments
  has_many :votes, as: :voteable

  validates :title, presence: true
  validates :creator, presence: true
  #validates :url, format: { with: %r{http://\w+.[a-z]{1,20}}i, message: 'must begin with http:// and contain only letters, numbers and underscores' }
  validate :format_of_the_url

  def total_votes
    positive_votes - negative_votes
  end

  def negative_votes
    self.votes.where(vote: false).size
  end

  def positive_votes
    self.votes.where(vote: true).size
  end

  private

  def format_of_the_url
    return if url =~ %r{http://\w+.[a-z]{1,20}}i
    errors.add(:url, 'the format of the url is invalid')
  end
end