require 'rubygems'
require 'sinatra'

BATCH = 100
DIR = File.dirname(__FILE__)

get '/' do
  File.read("#{DIR}/public/index.html")
end

get '/batch' do
  current = File.read("#{DIR}/current.txt").strip.to_i
  hashes = (current...(current + BATCH)).map { |i| ("%032s" % i.to_s(16)).gsub(' ', '0') }
  File.open("#{DIR}/current.txt", 'w') { |f| f.write(current + BATCH) }
  hashes * ','
end

post '/found/:hash' do |hash|
  File.open("#{DIR}/found.txt", 'a') { |f| f.write("#{hash}\n") }
end

