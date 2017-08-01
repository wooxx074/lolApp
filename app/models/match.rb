class Match < ApplicationRecord
  serialize :match_info, JSON
  serialize :pros_in_game, Array
  serialize :champs_pro_played, Array
  validates_uniqueness_of :game_id
  has_and_belongs_to_many :players
end