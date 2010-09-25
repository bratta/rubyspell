require 'pp'
require 'set'
require 'zlib'

# Load all files in lib/rubyspell/*.rb
Dir[File.join(File.dirname(__FILE__), 'rubyspell', '*.rb')].each {|file| require file }

module Rubyspell
end

