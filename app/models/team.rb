class Team < ApplicationRecord
  # Contract form validations
  validates :name, presence: true
  
  belongs_to :league
  has_many :players

  has_attached_file :avatar, 
                    :styles => { medium: "300x300>", thumb: "100x100>" }, 
                    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
end
