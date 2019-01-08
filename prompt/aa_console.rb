require '../commands/font_formatter'
require 'readline'
require './prompt'

help = File.read('help.txt')
prompt = Prompt.new
unless prompt.check_uid
  puts 'Please run as sudo'
  exit 1
end
puts 'Starting...'

while (input = Readline.readline(SetFont.underline('aa-console') + ' > ', true))

  cmd, *args = input.split
  case cmd
  when 'help'
    puts help
  when 'list'
    puts args
  when 'search'
    puts 'asda'
  when 'exit'
    exit 0
  when 'clear'
    system('clear') 
  else
    puts 'Unknown command'
  end
end