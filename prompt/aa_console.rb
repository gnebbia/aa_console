#!/usr/bin/env ruby

require '../commands/font_formatter'
require 'readline'
require './prompt'
require '../commands/CLICommand'
require '../commands/list'
require '../commands/search'
require '../commands/generate'
require '../commands/log_search'
require '../commands/change_prof'

cmd_list = %w[help list search generate log_search change_prof clear exit]

subcommands = {
  'list' => ListCLICommand,
  'search' => SearchCLICommand,
  'generate' => GenerateCLICommand,
  'log_search' => LogSearchCLICommand,
  'change_prof' => ChangeProfCLICommand
}

help = File.read('help.txt')
prompt = Prompt.new
unless prompt.check_uid
  puts 'Please run as sudo'
  exit 1
end
puts 'Starting...'
puts "
================================================
                 _____ _____
                |  _  |  _  |
                |     |     |
                |__|__|__|__|
   _____ _____ _____ _____ _____ __    _____
  |     |     |   | |   __|     |  |  |   __|
  |   --|  |  | | | |__   |  |  |  |__|   __|
  |_____|_____|_|___|_____|_____|_____|_____|

================================================
                                           "

while (input = Readline.readline(SetFont.underline('aa-console') + ' > ', true))

  cmd, *args = input.split
  if cmd_list.include?(cmd)
    puts help if cmd == 'help'
    exit 0 if cmd == 'exit'
    system('clear') if cmd == 'clear'
    subcommands[cmd].new(args) if subcommands.key?(cmd)
  else
    puts 'Unknown command'
  end
end