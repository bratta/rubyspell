# Rubyspell

The goal of this project is to create a pure-ruby spell checker and suggestion engine. 
The code is based on the Python code provided by Google's [Peter Norvig](http://norvig.com/spell-correct.html). 

## PLEASE NOTE:

This code is a work in progress. When the rspec tests pass with a > 75% accuracy rate I'll know we 
have a decent enough word frequency list to make this particular implementation plausible for use.
Until then it's more of a toy project.

## Building the dictionary

Right now I provide a script to build a dictionary from either a text file containing words, or a whitespace-delimited 
file containing words and their associated frequencies. This is in misc/create_dictionaries.rb right now. All it does 
is load the files into a ruby Hash, and marshal the object out to disk. This dramatically reduces startup time of the
speller object as opposed to parsing the entire text file on instantiation.

## TODO

The main thing is to get the rpsec tests to pass. Then this needs to be formatted to return some decent JSON to throw
inside of a web service (such as my toy site, isitaword.com). I also need to morph the create_dictionaries.rb script
into a full-blown command line spell checker. Then all I have to do is create the gem and push to gemcutter. 

If you have any suggestions, fixes, or whatnot, please submit me a pull request.

[Tim Gourley](http://timgourley.com)