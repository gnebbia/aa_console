require 'readline'

class Prompt

  def initialize
    @cmd_list = %w[list search clear help exit] # TODO: add commands
    complete_proc
  end

  # to be called in the main class
  def check_uid
    Process.uid.zero?
  end

  def complete_proc
    comp = proc { |cmd| @cmd_list.grep(/^#{Regexp.escape(cmd)}/) }
    Readline.completion_append_character = ' '
    Readline.completion_proc = comp
  end
end



