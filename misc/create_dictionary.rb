#!/usr/bin/env ruby
$:.unshift "#{File.dirname(__FILE__)}/../lib"

require 'rubygems'
require 'rubyspell'
require 'optiflag'

module CreateDictionary extend OptiFlagSet
  flag "textfile" do
     alternate_forms "txt", "text", "t", "T"
     description "Word list to load"
  end 
  flag "dictionary" do
     alternate_forms "dic", "d", "D"
     description "Dictionary file to save"
  end
  optional_switch_flag "frequency" do
     alternate_forms "freq", "f", "F"
     description "The word list contains frequency information"   
  end
  usage_flag "h", "help", "?", "usage"
  
  and_process!
end

speller = Rubyspell::Speller.new(:filename => ARGV.flags.textfile, :frequency_list => ARGV.flags.frequency?)
puts "Creating #{ARGV.flags.dictionary} from #{ARGV.flags.textfile}..."
speller.save_dictionary(ARGV.flags.dictionary)
puts "Done!"
