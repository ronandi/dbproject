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

csv_file = 'data/names.csv'
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
beerDB = DB[:beers]
bars = DB[:bars]
sells = DB[:sells]
frequents = DB[:frequents]
DB.run File.read('queries/beers.sql') if beerDB.count == 0
DB.run File.read('queries/bars.sql') if bars.count == 0
bar_names = bars.select(:name).all.map { |bar| bar[:name] }

#Populate database
id = 1;
CSV.foreach(csv_file, :headers => :first_row) do |row|
  user = {:id => id, :name => "#{row[0]} #{row[1]}",
          :gender => row[2], :address => row[3],
          :city => row[4], :phone => row[5],
          :age => 2013 - row[6].split('/')[2].to_i}
  #drinkers.insert(user)
  id += 1;
  favorite_beer = nil

  #If hipster then they like weird stuff
  if (user[:age] >= 22 && user[:age] <= 27 && current_hipsters < hipster_count)
    current_hipsters += 1
    firstbeer.insert({ :drinker_id => user[:id], :beer => odd_beers.sample})
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
    entry = { :drinker_id => user[:id], :beer => firstbeer_array.sample,
             :year => (2013 - (user[:age] - 21)) }
    firstbeer.insert(entry)

    if(user[:gender] = 'female')
      if(user[:age] < 30)
        farray = beerDB.select(:name).where{ibu < 25}
        favorite_beer = farray.to_a.sample[:name]
        larray = beerDB.select(:name).where(abv < 5)
        like_array = larray.to_a[:name]
        likes.insert({ :drinker_id => user[:id], :beer => favorite_beer })
        new_beers = like_array - [favorite_beer]
        rand(1..6).times do
          beer = new_beers.sample
          new_beers = new_beers - [beer]
          likes.insert({ :drinker_id => user[:id], :beer => beer })
        end
      elsif (user[:age] < 40)
        farray = beerDB.select(:name).where{ibu < 21}
        favorite_beer = farray.to_a.sample[:name]
        larray = beerDB.select(:name).where(abv < 4.6)
        like_array = larray.to_a[:name]
        likes.insert({ :drinker_id => user[:id], :beer => favorite_beer })
        new_beers = like_array - [favorite_beer]
        rand(1..6).times do
          beer = new_beers.sample
          new_beers = new_beers - [beer]
          likes.insert({ :drinker_id => user[:id], :beer => beer })
        end
      else
        farray = beerDB.select(:name).where{ibu < 16}
        favorite_beer = farray.to_a.sample[:name]
        larray = beerDB.select(:name).where(abv < 4.3)
        like_array = larray.to_a[:name]
        likes.insert({ :drinker_id => user[:id], :beer => favorite_beer })
        new_beers = like_array - [favorite_beer]
        rand(1..6).times do
          beer = new_beers.sample
          new_beers = new_beers - [beer]
          likes.insert({ :drinker_id => user[:id], :beer => beer })
        end
      end
    else
      if(user[:age] < 30)
        farray = beerDB.select(:name).where{ibu > 25}
        favorite_beer = farray.to_a.sample[:name]
        larray = beerDB.select(:name).where(abv > 4.6)
        like_array = larray.to_a[:name]
        likes.insert({ :drinker_id => user[:id], :beer => favorite_beer })
        new_beers = like_array - [favorite_beer]
        rand(1..6).times do
          beer = new_beers.sample
          new_beers = new_beers - [beer]
          likes.insert({ :drinker_id => user[:id], :beer => beer })
        end
      elsif (user[:age] < 40)
        farray = beerDB.select(:name).where{ibu > 34}
        favorite_beer = farray.to_a.sample[:name]
        larray = beerDB.select(:name).where(abv > 4.9)
        like_array = larray.to_a[:name]
        likes.insert({ :drinker_id => user[:id], :beer => favorite_beer })
        new_beers = like_array - [favorite_beer]
        rand(1..6).times do
          beer = new_beers.sample
          new_beers = new_beers - [beer]
          likes.insert({ :drinker_id => user[:id], :beer => beer })
        end
      else
        farray = beerDB.select(:name).where{ibu > 55}
        favorite_beer = farray.to_a.sample[:name]
        larray = beerDB.select(:name).where(abv > 5.1)
        like_array = larray.to_a[:name]
        likes.insert({ :drinker_id => user[:id], :beer => favorite_beer })
        new_beers = like_array - [favorite_beer]
        rand(1..6).times do
          beer = new_beers.sample
          new_beers = new_beers - [beer]
          likes.insert({ :drinker_id => user[:id], :beer => beer })
        end
      end
    end
    entry = {:drinker_id => user[:id], :beer => favorite_beer}
    favorite.insert(entry)
  end

  #Add frequents
  random_bar = bar_names.sample
  frequents.insert({ :drinker_id => user[:id], :bar => random_bar})
  if sells.where(:bar => random_bar, :beer => favorite_beer).first.nil?
    sells.insert(:bar => random_bar, :beer => favorite_beer, :price => rand(2..6).round(2))
  end

end
