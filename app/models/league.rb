class League < ApplicationRecord
<<<<<<< HEAD
  has_many :teams
  has_attached_file :avatar, 
                    :styles => { medium: "300x300>", thumb: "100x100>" }, 
                    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
=======
    has_many :teams
>>>>>>> Added new/edit/views to team and leagues, WIP
end
