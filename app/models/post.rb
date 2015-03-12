class Post < ActiveRecord::Base
  before_save :generate_slug
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

  def to_param
    self.slug
  end

  private

  def format_of_the_url
    return if url =~ %r{http://\w+.[a-z]{1,20}}i
    errors.add(:url, 'the format of the url is invalid')
  end

  def generate_slug
    the_slug = to_slug(self.title)
    post = Post.find_by slug: self.slug
    count = 2
    while post && post != self
      the_slug = append_postfix(the_slug, count)
      post = Post.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug
  end

  def append_postfix(str, count)
    if str =~ /\-/
      pieces = str.split('-')
      if pieces.last.to_i != 0
        return pieces.slice(0...-1).join('-') + '-' + count.to_s
      end
    end
    str + '-' + count.to_s
  end

  def to_slug(name)
    str = name.strip
    str.gsub!(%r{\s*[^0-9a-zA-Z]\s*}, '-')
    str.gsub!(%r{\-+$}, '-')
    str.gsub!(%r{(^\-|\-$)},'')
    str.downcase
    str
  end

end