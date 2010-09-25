require 'spec_helper'

describe Rubyspell::Speller, "when instantiating the object" do
  before(:all) do
    @speller = Rubyspell::Speller.new
  end
  it "should have a valid wordlist" do
    @speller.wordlist.count.should > 0
  end
end

describe Rubyspell::Speller, "when making suggestions for misspelled words" do
  before(:all) do
    @speller = Rubyspell::Speller.new
  end
  it "should return the same word for properly spelled words" do
    words = ['beef', 'chicken', 'pork', 'principal', 'horn', 'spine']
    words.each do |word|
      @speller.correct(word).should == word
    end
  end
  
  it "should correct with the proper suggestion" do
    words = { 'acceptible' => 'acceptable', 'acommodate' => 'accommodate', 'conscienscous' => 'conscientious', 
              'definitly' => 'definitely', 'guage' => 'gauge', 'heirarchy' => 'hierarchy', 
              'innoculate' => 'inoculate', 'lisence' => 'license', 'mispell' => 'misspell', 
              'occurrance' => 'occurrence', 'personell' => 'personnel', 'relevent' => 'relevant', 
              'seperate' => 'separate', 'wierd' => 'weird' }
    correct = 0
    words.each do |wrong, right|
      correct += 1 if @speller.correct(wrong) == right
    end
    percentage_correct = ((correct.to_f / words.length.to_f) * 100).to_i
    puts "Percentage of words correctly suggested = #{percentage_correct}%"
    percentage_correct.should > 75
  end
  
  it "should have no suggestions for completely wrong words" do
    words = ['asdfasdf', 'jdfsjklfdsajlkfds', 'nbfa9idf', 'supercalifragilisticexpialidocious']
    words.each do |word|
      @speller.correct(word).should == nil
    end
  end
end