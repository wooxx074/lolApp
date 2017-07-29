class Player < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, :slug, presence: true
  serialize :summonername, Hash
  belongs_to :team
  has_and_belongs_to_many :matches
  has_attached_file :avatar, 
                    :styles => { medium: "300x300>", thumb: "100x100>" }, 
                    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
end
