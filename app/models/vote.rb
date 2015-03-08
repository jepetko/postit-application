class Vote < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :voteable, polymorphic: true

  #scope :positive_votes_count, lambda { |voteable| where(voteable_type: voteable.class.name, voteable_id: voteable.id, vote: true).size }
  #scope :negative_votes_count, lambda { |voteable| where(voteable_type: voteable.class.name, voteable_id: voteable.id, vote: false).size}
  #scope :total_votes_count, lambda { |voteable| positive_votes_count(voteable)-negative_votes_count(voteable) }

  validates_uniqueness_of :creator, scope: [:voteable, :voteable_type]
end