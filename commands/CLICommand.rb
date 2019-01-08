# Generic CLICommand class that defines the structure to be
# extended by all possible console subcommands.

class CLICommand

  def initialize(option = nil)
    parse_option(option)
  end

  def parse_option(option)
    raise NotImplementedError
  end

  def print_help
    raise NotImplementedError
  end
end

