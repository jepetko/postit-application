class Comment < ActiveRecord::Base
  belongs_to :creator, :foreign_key => 'user_id', :class_name => 'User'
  belongs_to :post

  validates :body, :presence => true
  validates_length_of :body, minimum: 3, tokenizer: Proc.new { |body| body.split(/\w+/) }, too_short: 'is too short. Post a meaningful message.'
  validates_length_of :body, maximum: 100, tokenizer: Proc.new { |body| body.split(/\w+/) }, too_long: 'is too long. This is not an essay.'
  validate :suitable_body_content

  private
  def suitable_body_content
    if body =~ /(some|bad|words|here)/i
      errors.add(:body, 'has been declined. Think twice.')
    end
  end
end