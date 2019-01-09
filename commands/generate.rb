# Command to generate a profile using `genprof`
# If the `-m` flag is enabled the generation will
# be done in manual mode (i.e. manually write the policy in a
# text editor)

require '../commands/CLICommand'
require '../commands/font_formatter'

class GenerateCLICommand < CLICommand
  def initialize(args = nil)
    if args[0]
      parse_option(args)
    else
      puts_err
    end
  end

  def puts_err
    puts '[name] is required'
  end

  def parse_option(args)
    name = args[0]
    if args[0] == 'help'
      print_help
    else
      if args[1]
        man_gen(name)
      else
        auto_gen(name)
      end
    end
  end

  def man_gen(name)
    system("sudo vim /etc/apparmor.d/#{name}")
  end

  def auto_gen(name)
    system("sudo aa-genprof #{name}")
  end

  def print_help
    puts 'generate [name]  - generate prof
                   with given name
    -m   [name]  - launch generate
                   in manual mode
    help         - show usage'
  end
end