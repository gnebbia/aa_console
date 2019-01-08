require '../commands/font_formatter'
require 'readline'
require './prompt'
require '../commands/CLICommand'
require '../commands/list'
require '../commands/search'

cmd_list = %w[help list search clear exit]

subcommands = {
  'list' => ListCLICommand,
  'search' => SearchCLICommand
}

help = File.read('help.txt')
prompt = Prompt.new
unless prompt.check_uid
  puts 'Please run as sudo'
  exit 1
end
puts 'Starting...'

while (input = Readline.readline(SetFont.underline('aa-console') + ' > ', true))

  cmd, *args = input.split
  if cmd_list.include?(cmd)
    puts help if cmd == 'help'
    exit 0 if cmd == 'exit'
    system('clear') if cmd == 'clear'
    subcommands[cmd].new(args[0]) if subcommands.key?(cmd)
  else
    puts 'Unknown command'
  end
end