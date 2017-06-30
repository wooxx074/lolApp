class Player < ApplicationRecord
<<<<<<< HEAD
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, :slug, presence: true
  serialize :summonername, Hash
  belongs_to :team
  has_attached_file :avatar, 
                    :styles => { medium: "300x300>", thumb: "100x100>" }, 
                    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
=======
  belongs_to :team
>>>>>>> Added new/edit/views to team and leagues, WIP
end
