# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
["LCK", "NA LCS", "EU LCS", "LMS"].each do |team|
    League.create(name:"#{team}")
    league = League.find_by_name(team)
    10.times do |t|
        Team.create(name:"#{team} #{t+1}", league_id: league.id )
        t += 1
    end
end