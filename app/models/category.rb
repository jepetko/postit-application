class Category < ActiveRecord::Base

  include Sluggable

  validates :name, :presence => true
  has_many :post_categories, dependent: :destroy
  has_many :posts, :through => :post_categories

  def field_value_as_slug
    self.name
  end
end