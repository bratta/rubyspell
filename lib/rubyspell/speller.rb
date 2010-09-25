# Ruby-only spell checker
# Many thanks to reading up on spell-checking theory
# From http://norvig.com/spell-correct.html

module Rubyspell
  class Speller
    attr_accessor :wordlist, :options
  
    # Prefer loading a gzipped marshaled hash that contains
    # our wordlist and frequency counts. Otherwise load from
    # a text file. Loading from a text file significantly 
    # impacts performance and memory use, so be warned.
    def initialize(options = {})
      @options = { 
        :filename => "#{File.dirname(__FILE__)}/dictionaries/wordlist.dic",
        :text_ext => ".txt",
        :alphabet => 'abcdefghijklmnopqrstuvwxyz'
      }
      @options.merge!(options)      
      load_wordlist
    end
  
    # Not poorly named: return a set of words that are an 
    # edit distance of one from the word
    def edit_distance_one(word)
      splits = Array.new; (0..word.length).each { |i| splits << [word[0,i], word[i,word.length]] }
      deletes = Array.new; splits.each { |a,b| deletes << "#{a}#{b[1,b.length]}" if !b.empty? }
      transposes = Array.new; splits.each { |a,b| transposes << "#{a}#{b[1,1]}#{b[0,1]}#{b[2,b.length]}" if b.length > 1}
      replaces = Array.new; splits.each {|a,b| @options[:alphabet].split('').each {|c| replaces << "#{a}#{c}#{b[1,b.length]}" if !b.empty?}}
      inserts = Array.new; splits.each {|a,b| @options[:alphabet].split('').each {|c| inserts << "#{a}#{c}#{b}" }}
      Set.new(deletes + transposes + replaces + inserts)
    end
  
    # Not poorly named: return a set of words that are an
    # edit distance of two from the word
    # pass :known => false to remove the limit of known words only
    def edit_distance_two(word, options={:known => true})
      edit_two = Set.new
      edit_distance_one(word).each do|e1| 
        edit_distance_one(e1).each do |e2| 
          edit_two << e2 if options[:known] == false || @wordlist.include?(e2)
        end
      end
      edit_two
    end
  
    # Given an array/set of words, create a set containing only those
    # words that are known to our compiled wordlist. 
    def known(words)
      known_words = Set.new
      words.each do |w|
        known_words << w if @wordlist.include?(w)
      end
      known_words
    end
  
    # This part uses a simplified model of spelling errors.
    def correct(word)
      candidates = Set.new
      # The word is known, so let's use it.
      candidates = known([word])
      # The word is misspelled, and it is more likely candidates are one edit distance away
      candidates = known(edit_distance_one(word)) if candidates.empty?
      # The word is misspelled with no one-edit candidates, so it is likely 
      # that candidates are two edit distances away
      candidates = edit_distance_two(word) if candidates.empty?
      # No suggestions other than the word itself, so this word is just plain wrong
      # But if you'd rather have the misspelled word returned as a candidate, use this:
      #   candidates << [word] if candidates.empty? 
    
      # Return our word or suggestion based on the frequency of the word in the wordlist
      candidates.max{ |a,b| @wordlist[a] <=> @wordlist[b] }
    end
  
    # Load the gzipped dictionary and unmarshal the data
    def load_dictionary(input_filename)
      begin
        file = Zlib::GzipReader.open(input_filename)
      rescue Zlib::GzipFile::Error
        file = File.open(input_filename, 'r')
      ensure
        obj = Marshal.load file.read
        file.close
        return obj
      end
    end
  
    # Marshal the data and save a gzipped version
    def save_dictionary(output_filename)
      marshal_dump = Marshal.dump(@wordlist)
      file = File.new(output_filename,'w')
      file = Zlib::GzipWriter.new(file)
      file.write marshal_dump
      file.close    
    end
  
    private
  
    # Populates @wordlist with the proper words and their
    # frequencies, either from a text file or from the 
    # marshaled dictionary. The text file can either
    # be a list of words, or it can be a list of words with
    # an associated frequency (separated by whitespace)
    def load_wordlist
      if @options[:filename] =~ /#{Regexp.escape(@options[:text_ext])}$/
        if @options[:frequency_list]
          @wordlist = load_words_from_frequency_list(@options[:filename])
        else
          @wordlist = load_words(@options[:filename])
        end
      else
        @wordlist = load_dictionary(@options[:filename])
      end      
    end
    
    # Make our wordlist smart
    # Ok, not really. All this does is add each word to our 
    # wordlist hash and maintain the frequency for statistical
    # information of the probability of the word being the 
    # correct suggestion for a misspelled word.
    def train(features)
      model = Hash.new #{ |h,k| h[k] = 1 }
      features.each do |feature| 
        model[feature] = 1 if !model[feature]
        model[feature] += 1
      end
      return model
    end

    # We're just interested in alphabetic lowecase strings
    def words(text)
      text.downcase.scan(/[a-z]+/)
    end

    # Open the file and parse our contents. This is 
    # a heavy and slow operation, making it more
    # attractive to do it once and just load the marshaled
    # data from disk.
    def load_words(filename)
      train(words(File.open(filename).read()))
    end
    
    # Use this if you have a pre-trained frequency list
    # you want to load into memory. Again you'll want to
    # do this once and marshal it out to disk
    def load_words_from_frequency_list(filename)
      word_list = Hash.new
      File.open(filename, 'r') do |file|
        line = file.gets # ignore the first line of header info
        while (line = file.gets)
          frequency_data = line.split(/\s+/)
          word_list[frequency_data[0]] = frequency_data[1].to_i
        end
      end
      word_list
    end      
  end
end