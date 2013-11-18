require 'sequel'
require 'irb'
user = ENV['cs336user'] || "Your user here"
pass = ENV['cs336pass'] || "Your pass here"
DB = Sequel.connect("mysql2://#{user}:#{pass}@cs336-24.cs.rutgers.edu/project")
IRB.start
