#!/usr/bin/ruby
# Ruby Script for "The Kember Identity"
#
# Copyright (c) 2009 Markus Anders
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without warranty of any kind.

require 'digest/md5'
require 'yaml'
require 'find_speed.rb'

# Helper class that saves the current status to a file
# Format of the file is YAML with the following parts:
# --- 
# :max: endpoint (default = 2 ** 32 - 1)
# :start: startpoint (default = 0)
# :last: last number checked. (default = startpoint)
# :chunk_size: number of hashes checked without interruption
# If one or more hashes are found, the file gets extended by:
# :hits:
# - hash
#
# Create multiple status files if you want the script to run on several
# computers, or if you have multiple cpus. Be sure to use different values for
# :start/:last and :max for each file. Use random values if you want some
# randomness.
class StatusFile
  
  FILE_NAME = 'status.yaml'
  attr_reader :max, :last, :chunk_size, :min
  
  def initialize( filename = FILE_NAME )
    @filename   = filename
    @params     = load_or_create_file
    @max        = @params[:max]
    @min        = @params[:min]
    @last       = @params[:last]
    @chunk_size = @params[:chunk_size]
    self
  end
  
  # Save the last checked number as a point the script can resume from any time
  def last=( current )
    @last = current
    save
  end
  
  # Save the hit; more than one hit possible
  def hit( current )
    @params[:hits] ||= []
    @params[:hits] << current
    save
    sleep 1 # avoid problems with filehandling
  end
  
  private
  
  # overwrites the content of the file with the actual @params
  def save
    @params[:last] = @last
    File.open(@filename, "w") { |f| f.write(@params.to_yaml) }
  end
  
  # Loads the status file or creates it with default values if it doesn't
  # exist. Values of a newly created file should be edited to be more useful.
  def load_or_create_file
    if File.exists?(@filename)
      params = YAML.load_file(@filename)
    else
      max = 2 ** 128 - 1
      params = { :max => max, :min => 0, :last => 0, :chunk_size => 10000000 }
      File.open(@filename, "w") { |f| f.write(params.to_yaml) }
    end
    params
  end
  
end

# The main class; Supports two search methods:
# search() => structured search using chunks of integers
# search_random() => faster random search
class KemberIdentity
  
  # Constructor; sets verbose mode and the status file which should be used.
  def initialize( file, verbose = false )
    @file    = file
    @verbose = verbose
    @speed   = FindSpeed.new( @file.chunk_size )
    self
  end
  
  # Method with the important part: iterate, convert to hex, compare with md5
  # Uses chunks of integers and iterates over them. Each integer is converted
  # to a hex string. Integers are provided by a StatusFile object.
  def search
    start, stop = next_chunk
    # Big loop from :start to :max in status.yaml
    while start < stop
      @speed.start
      # Loop for smaller chunks; it's the only relevant part for performance
      (start..stop).each do |number|
        current = number.to_s(16).rjust(32,'0')
        if current == Digest::MD5.hexdigest(current)
          puts "found one! #{current}" if @verbose
          @file.hit(current)
        end
      end
      @file.last = stop
      speed_string = "with #{@speed.stop} hashes/s"
      start, stop = next_chunk(speed_string)
    end
    puts "reached maximum of #{@file.max}..." if @verbose
  end

  # Pure random approach, if you don't like the structured search used in the
  # normal search method. Results are saved with StatusFile, though.
  # About 50% faster than search(). Even more for large numbers (hashes
  # near fffff...) and less for small numbers (hashes near 00000...).
  def search_random
    valid_chars = ('0'..'9').to_a + ('a'..'f').to_a
    current     = rand(2 ** 128 - 1).to_s(16).rjust(32,'0')
    puts "start performing random search..." if @verbose
    # Repeat until Ctrl+c
    loop do
      @speed.start
      # Performance relevant part; just compare and change string
      @file.chunk_size.times do
        if current == Digest::MD5.hexdigest(current)
          puts "found one! #{current}" if @verbose
          @file.hit(current)
        end
        # Just change one random char of the hash
        current[rand(32)] = valid_chars[rand(16)]
      end
      puts "Speed for last #{@file.chunk_size} random hashes:" +
        " #{@speed.stop} hashes/s" if @verbose
    end
  end

  private
  
  # returns the start- and endpoint of the next chunk to check
  def next_chunk( speed_string = "" )
    start = @file.last
    stop  = @file.last + @file.chunk_size
    if stop > @file.max
      stop = @file.max
    end
    puts "processing #{start}-#{stop} #{speed_string}" if @verbose
    [start, stop]
  end
  
end

# Starts the script
# Commandline options: -v => verbose mode (recommend)
# -f <statusfile> => custom status file, useful for running 2 or more instances
# of this script at the same time (multi cpu usage)
# -r => pure random mode. Some values of the status file are not used.
verbose = ARGV.include?("-v")

if ARGV.include?("-f")
  file = StatusFile.new(ARGV[ARGV.index("-f") + 1])
else
  file = StatusFile.new
end

ki = KemberIdentity.new(file, verbose)

if ARGV.include?("-r")
  ki.search_random
else
  ki.search
end
