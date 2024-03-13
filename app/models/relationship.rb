class Relationship < ApplicationRecord
    belongs_to :follower, class_name: User.name, foreign_key: :follower_id
    belongs_to :followed, class_name: User.name, foreign_key: :followed_id
    validates :followed_id, presence: true
    validates :follower_id, presence: true
end
