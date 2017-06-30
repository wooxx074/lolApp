class Team < ApplicationRecord
  # Contract form validations
  validates :name, presence: true
  
  belongs_to :league
  has_many :players

end