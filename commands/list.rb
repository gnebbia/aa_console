# Command to list the profiles
# It accepts the following flag
# --all        =   to show all the profiles
# --complain   =   to show all the profiles in complain-mode
# --enforce    =   to show all the profiles in enforce mode

require_relative 'CLICommand'
require_relative 'font_formatter'
require '../exceptions/FlagRequired'

class ListCLICommand < CLICommand

  def initialize(option = nil)
    if option[0]
      parse_option(option[0])
    else
      begin
        raise FlagRequired.new(' [type] ', 'is required')
      rescue StandardError => e
        puts e.message
      end
    end
    end

  def unknown_cmd
    puts 'Unknown arg'
  end

  def parse_option(option)
    if option == 'help'
      print_help
    elsif %w[enforce complain all].include?(option)
      list = generate_list
      parse_list(option, list)
    else
      unknown_cmd
    end
  end

  def generate_list
    list = `sudo aa-status`
    list.lines.map(&:chomp)
  end

  def parse_list(option, list)
    case option
    when 'enforce'
      print_enforce(list)
    when 'complain'
      print_complain(list)
    else print_all(list)
    end
  end

  def print_enforce(list)
    c_list = clean_list(list)
    puts SetColor.yellow('ENFORCE')
    [0...@enforce_cnt].each do |i|
      puts c_list[i]
    end
  end

  def print_complain(list)
    c_list = clean_list(list)
    total = @enforce_cnt + @complain_cnt
    puts SetColor.yellow('COMPLAIN')
    [@enforce_cnt...total].each do |i|
      puts c_list[i]
    end
  end

  def print_all(list)
    c_list = clean_list(list)
    puts SetColor.yellow('ENFORCE')
    [0...@enforce_cnt].each do |i|
      puts c_list[i]
    end
    puts SetColor.yellow('COMPLAIN')
    [@enforce_cnt...@enforce_cnt + @complain_cnt].each do |j|
      puts c_list[j]
    end
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

  def print_help
    puts "list [type]
      all          - show all profiles
      enforce      - show enforce
      complain     - show complain"
  end

end