require 'rubygems'
require 'sequel'
require 'csv'

csv_file = 'names.csv'
user = ENV['cs336user'] || "Your user here"
pass = ENV['cs336pass'] || "Your pass here"

DB = Sequel.connect("mysql2://#{user}:#{pass}@cs336-24.cs.rutgers.edu/project")
drinkers = DB[:drinkers]

CSV.foreach(csv_file, :headers => :first_row) do |row|
  user = {:name => "#{row[0]} #{row[1]}",
                  :gender => row[2], :address => row[3],
                  :city => row[4], :phone => row[5],
                  :age => 2013 - row[6].split('/')[2].to_i}
  drinkers.insert(user)
end
