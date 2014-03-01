#!/usr/bin/env ruby

if ARGV.length < 3
	puts '''
Usage    : ./random_files.rb NUMBER_OF_FILES FILE_SIZE DESTINATION_DIR
Example  : ./random_files.rb 10 10m ~/files
	'''
else
	number_of_files = ARGV[0]
	file_size = ARGV[1]
	destination_dir = ARGV[2]
	block_size = 1024
	no_of_blocks = (file_size.to_i / block_size).to_i
	
	for i in 0...number_of_files.to_i
		file_name = Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
		path = File.absolute_path("#{file_name}_#{file_size}.tmp", destination_dir).gsub(' ', '\ ')
	
		# system "mkfile #{file_size} #{path}"
		system "dd if=/dev/random of=#{path} count=#{no_of_blocks} bs=#{block_size}"
	end
end
