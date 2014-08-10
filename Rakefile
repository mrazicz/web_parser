# encoding: utf-8

require 'rubygems'
require 'bundler'

require './lib/web_parser.rb'

task :console do
  require 'pry'
  ARGV.clear
  Pry.start WebParser
end
task :c => :console

