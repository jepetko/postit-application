class Vote < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :voteable, polymorphic: true

  #scope :positive_votes_count, lambda { |voteable| where(voteable_type: voteable.class.name, voteable_id: voteable.id, vote: true).size }
  #scope :negative_votes_count, lambda { |voteable| where(voteable_type: voteable.class.name, voteable_id: voteable.id, vote: false).size}
  #scope :total_votes_count, lambda { |voteable| positive_votes_count(voteable)-negative_votes_count(voteable) }

  validates_uniqueness_of :creator, scope: [:voteable, :voteable_type]
  # the same:
  # validates_uniqueness_of :creator, scope: [:voteable_id, :voteable_type]


  def self.positive_votes_count(voteable)
    where(voteable: voteable, vote:true).size
  end

  def self.negative_votes_count(voteable)
    where(voteable: voteable, vote:false).size
  end

  def self.total_votes_count(voteable)
    positive_votes_count(voteable) - negative_votes_count(voteable)
  end

end