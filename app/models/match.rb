class Match < ApplicationRecord
  serialize :match_info, JSON
  serialize :pros_in_game, Array
  serialize :champs_pro_played, Array
  has_and_belongs_to_many :players
end