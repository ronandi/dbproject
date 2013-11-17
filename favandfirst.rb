require 'rubygems'
require 'sequel'
require 'csv'

class Drinker
	attr_accessor :id, :name, :gender, :address, :city, :phone, :age

	def initialize(id, name, city, phone, address, gender, age)
		@id = id
		@name = name
		@gender = gender
		@address = address
		@city = city
		@phone = phone
		@age = age
	end
end

class Beer
	attr_accessor :name, :manf, :region, :ibu, :abv, :type

	def initialize(name, manf, region, ibu, abv, type)
		@name = name
		@manf = manf
		@region = region
		@ibu = ibu
		@abv = abv
		@type = type
	end
end


drinker_csv_file = 'drinkers.csv'
drinker_array = []
CSV.foreach(drinker_csv_file, :headers => :first_row) do |row|
	drinker_array << Drinker.new(row[0], row[1], row[2], row[3], row[4], row[5], row[6])
end

beers_csv_file = 'beers.csv'
beers_array = []
CSV.foreach(beers_csv_file, :headers => :first_row) do |row|
	beers_array << Beer.new(row[0], row[1], row[2], row[3], row[4], row[5])
end

user = ENV['cs336user'] || "Your user here"
pass = ENV['cs336pass'] || "Your pass here"

DB = Sequel.connect("mysql2://#{user}:#{pass}@cs336-24.cs.rutgers.edu/project")
firstbeer = DB[:firstbeer]

firstbeer_array = ['Budweiser Light', 'Budweiser Light Platinum', 'Busch Light', 'Coors Light', 'Corona Light', 'Heineken Light', 'Miller Lite', 'Yuengling Light']
drinker_array.each do |n|
	if(n.age >= 22 && n.age <= 27)
		next
	end
	entry = {:drinker_id = n.id, :beer = firstbeer_array.sample , :age = (2013 - (n.age - 21))}
	firstbeer.insert(entry)
end

beerDB = DB[:beers]

favoritebeer = DB[:favorite]
drinker_array.each do |n|
	if(n.age >= 22 && n.age <= 27)
		next
	end
	fbeer
	if(n.gender = 'female')
		if(n.age < 30)
			farray = beerDB.select(:name).where{ibu < 25}
			fbeer = farray.sample
		end 
		else if (n.age < 40)
			farray = beerDB.select(:name).where{ibu < 21}
			fbeer = farray.sample
		end
		else
			farray = beerDB.select(:name).where{ibu < 16}
			fbeer = farray.sample
		end
	end
	else
		if(n.age < 30)
			farray = beerDB.select(:name).where{ibu > 25}
			fbeer = farray.sample
		end 
		else if (n.age < 40)
			farray = beerDB.select(:name).where{ibu > 34}
			fbeer = farray.sample
		end
		else
			farray = beerDB.select(:name).where{ibu > 55}
			fbeer = farray.sample
		end
	end
	entry = {:drinker_id = n.id, :beer = fbeer}
	favoritebeer.insert(entry)
end