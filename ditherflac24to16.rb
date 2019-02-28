#!/usr/bin/env ruby

require 'fileutils'
require 'find'
require 'open3'

source_path = ARGV[0]
destination_path = ARGV[1]
sample_rate = ARGV[2]

if sample_rate.empty?
  real_sample_rate = '48000'
else
  real_sample_rate = sample_rate.to_s
end

def create_directory(destination_path)
  FileUtils.mkdir_p(destination_path) unless File.exists?(destination_path)
end

def get_flac_paths(source_path)
  flac_file_paths = Find.find(source_path).select {|f| /.*\.flac$/ =~ f}
end

# Get a list of all non-FLAC files in source_path
def get_non_flac_paths(source_path)
  non_flac_file_paths = Find.find(source_path).reject {|f| f.end_with?(".flac")}
  non_flac_file_paths.reject! {|e| !File.file?(e) }
  return non_flac_file_paths
end

def get_flac_files(flac_paths)
  flac_files = []
  flac_paths.each do |path|
    flac_files << File.basename(path)
  end
  return flac_files
end

def get_non_flac_files(non_flac_paths)
  non_flac_files = []
  non_flac_paths.each do |path|
    non_flac_files << File.basename(path)
  end
  return non_flac_files
end

def copy_non_flac_files(source_files, destination_path)
  FileUtils.cp source_files, destination_path
end

# sox -V3 -S --buffer 131072 --multi-threaded <source_path>/<source_file> -G -b 16 <destination_path>/<destination_file> rate -v -L 48000 dither
def dither24to16(source_path, destination_path, files, sample_rate)
  files.each do |file|
    Open3.popen2('sox', '-V3', '-S', '--buffer', '131072', '--multi-threaded', "#{source_path}/#{file}", '-G', '-b', '16', "#{destination_path}/#{file}", 'rate', '-v', '-L', sample_rate, 'dither') do |stdin, stdout, status_thread|
      stdout.each_line do |line|
        puts "LINE: #{line}"
      end
      raise "failed" unless status_thread.value.success?
    end
  end
end

#create_directory(WORKDIR)
#file_paths = get_flac_paths(get_path(WORKDIR))
#get_flac_files(file_paths)
#pp get_source_path(WORKDIR)

create_directory(destination_path)
flac_files_with_paths = get_flac_paths(source_path)
flac_files_without_paths = get_flac_files(flac_files_with_paths)
dither24to16(source_path, destination_path, flac_files_without_paths, real_sample_rate)
non_flac_files_with_paths = get_non_flac_paths(source_path)
copy_non_flac_files(non_flac_files_with_paths, destination_path)


