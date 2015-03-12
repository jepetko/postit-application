class Category < ActiveRecord::Base

  before_save :generate_slug

  validates :name, :presence => true
  has_many :post_categories, dependent: :destroy
  has_many :posts, :through => :post_categories

  def to_param
    self.slug
  end

  private
  def generate_slug
    self.slug = self.name.gsub(%r{\s+}, '-').downcase
  end
end