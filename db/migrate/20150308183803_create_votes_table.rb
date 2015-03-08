class CreateVotesTable < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :vote
      t.integer :user_id
      # the same thing: polymophic: true
      t.string :voteable_type
      t.integer :voteable_id
      # the same thing as above
      #t.references :voteable, polymorphic: true
      t.timestamps
    end
  end
end
