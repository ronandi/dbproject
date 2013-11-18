require 'rubygems'
require 'sequel'
require 'csv'

#Constants / Settings
odd_beers       = ["Redhook Nut Brown", "Redbook IPA", "Redhook Hefe-weizen", "Redhook ESB",
                  "Redhook Blonde Ale", "Stone Imperial Russian Stout", "Serpents Stout",
                    "Old Rasputin Russian Imperial Stout", "Guiness Extra Stout", "Dragon Stout"]

firstbeer_array = ['Budweiser Light', 'Budweiser Light Platinum', 'Busch Light',
                   'Coors Light', 'Corona Light', 'Heineken Light', 'Miller Lite',
                   'Yuengling Light']

csv_file = 'names.csv'
total_count = 10_000
hipster_rate = 0.25
hipster_count = 250
current_hipsters = 0
user = ENV['cs336user'] || "Your user here"
pass = ENV['cs336pass'] || "Your pass here"

#DB connection
DB = Sequel.connect("mysql2://#{user}:#{pass}@cs336-24.cs.rutgers.edu/project")

#Tables
drinkers = DB[:drinkers]
likes = DB[:likes]
favorite = DB[:favorite]
firstbeer = DB[:firstbeer]

#Populate database
id = 1;
CSV.foreach(csv_file, :headers => :first_row) do |row|
  hipster = false
  user = {:id => id, :name => "#{row[0]} #{row[1]}",
          :gender => row[2], :address => row[3],
          :city => row[4], :phone => row[5],
          :age => 2013 - row[6].split('/')[2].to_i}
  drinkers.insert(user)
  id += 1;

  #If hipster then they like weird stuff
  if (user[:age] >= 22 && user[:age] <= 27 && current_hipsters < hipster_count)
    favorite_beer = odd_beers.sample
    favorite.insert({ :drinker_id => user[:id], :beer => favorite_beer })
    likes.insert({ :drinker_id => user[:id], :beer => favorite_beer })
    new_beers = odd_beers - [favorite_beer]
    rand(2..5).times do
      beer = new_beers.sample
      new_beers = new_beers - [beer]
      likes.insert({ :drinker_id => user[:id], :beer => beer })
    end
  else
    entry = {:drinker_id => user[:id], :beer => firstbeer_array.sample,
             :year => (2013 - (user[:age] - 21))}
    firstbeer.insert(entry)
    
    fbeer = nil
    if(user[:gender] = 'female')
      if(user[:age] < 30)
        farray = beerDB.select(:name).where{ibu < 25}
        fbeer = farray.sample
      elsif (user[:age] < 40)
        farray = beerDB.select(:name).where{ibu < 21}
        fbeer = farray.sample
      else
        farray = beerDB.select(:name).where{ibu < 16}
        fbeer = farray.sample
      end
    else
      if(user[:age] < 30)
        farray = beerDB.select(:name).where{ibu > 25}
        fbeer = farray.sample
      elsif (user[:age] < 40)
        farray = beerDB.select(:name).where{ibu > 34}
        fbeer = farray.sample
      else
        farray = beerDB.select(:name).where{ibu > 55}
        fbeer = farray.sample
      end
    end
  entry = {:drinker_id => user[:id], :beer => fbeer}
  favoritebeer.insert(entry)
  end
end
