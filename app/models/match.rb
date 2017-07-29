class Match < ApplicationRecord
  serialize :match_info, JSON
  serialize :pros_in_game, Array
end