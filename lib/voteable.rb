module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable
  end

  def total_votes
    positive_votes - negative_votes
  end

  def negative_votes
    self.votes.where(vote: false).size
  end

  def positive_votes
    self.votes.where(vote: true).size
  end
end

=begin
module Voteable

  def self.included(clazz)
    clazz.class_eval do
      has_many :votes, as: :voteable
    end
    clazz.extend ClassMethods
  end

  def total_votes
    positive_votes - negative_votes
  end

  def negative_votes
    self.votes.where(vote: false).size
  end

  def positive_votes
    self.votes.where(vote: true).size
  end

  module ClassMethods
    def top_voteables(limit)
      self.joins(:votes).group('posts.id').order('COUNT(*) desc').limit(limit).count
    end
  end

end
=end