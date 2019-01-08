# Command to search for a specic profile
# passing a string to it

require '../commands/CLICommand'
require '../commands/font_formatter'

class SearchCLICommand < CLICommand
  def initialize(args = nil)
    @found_profs = ''
    if args 
      parse_option(args)
    else
      puts_err
    end
  end

  def puts_err
    puts "[String] is required"
  end

  def parse_option(arg)
    if arg == 'help'
      print_help
    else
      print_found(arg)
    end
  end

  def generate_list
    list = `sudo aa-status`
    list.lines.map(&:chomp)
  end

  def clean_list(list)
    @enforce_cnt = get_enforce_count(list)
    @complain_cnt = get_complain_count(list)
    list.slice!(0..2)
    list.delete_at(@enforce_cnt)
    list.slice!(@enforce_cnt + @complain_cnt..-1)
    list
  end

  def get_enforce_count(list)
    list[2].split[0].to_i
  end

  def get_complain_count(list)
    list[@enforce_cnt + 3].split[0].to_i
  end

  def search_prof(tbf_prof)
    flag = SetColor.yellow('enforce')
    list = generate_list
    c_list = clean_list(list)
    c_list.each do |prof|
      flag = SetColor.yellow('complain') if c_list.index(prof).to_i >= @enforce_cnt
      @found_profs += prof + "\t #{flag} \n" if prof.include?(tbf_prof)
    end
    @found_profs
  end

  def print_found(prof)
    to_be_printed = search_prof(prof)
    if to_be_printed.to_s.empty?
      puts SetColor.red('No profiles found')
    else
      puts to_be_printed
    end
  end

  def print_help
    puts "search [string]  - search for a profile matching string"
  end
end
