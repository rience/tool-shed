#!/usr/bin/env ruby
require 'ptools'

if ARGV.length != 3
  puts '''
Usage   : ./search_and_replace DIR FIND REPLACE
Example : ./search_and_replace ~/Documents/workspace "foo" "bar"
'''
  exit -1
end

class Scanner
  
  attr_accessor :directory, :search_pattern, :replace_string, :extensions
  
  def initialize
    @directory = nil
    @extensions = ['.h', '.m']
  end
  
  def start
    scan(@directory)
  end
  
  
  def scan(dir)
  
    Dir.foreach(dir) do |item|
  
      next if item == '.' or item == '..'
  
      full_path = File.join(dir, item)
  
      if File.directory?(full_path)
        self.scan(full_path)
      else
        
        if !File.binary?(full_path) && @extensions.include?(File.extname(full_path))
          process_file(full_path) unless File.binary?(full_path)
        end
      end
    end
  end
  
  def process_file(path)
    print "Processing File = #{path}\n"
    
    file_content = File.read(path)
    file_processed_content = file_content.gsub(@search_pattern, @replace_string)
    
    if file_content != file_processed_content
      system "p4 edit \"#{path}\""
    
      File.write(path, file_processed_content)
    end
  end
  
end

scanner = Scanner.new
scanner.directory = ARGV[0]
scanner.search_pattern = ARGV[1]
scanner.replace_string = ARGV[2]
scanner.start()