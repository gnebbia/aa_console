require_relative 'CLICommand'
require '../exceptions/FlagRequired'

class ChangeProfCLICommand < CLICommand
  attr_reader :c_list

  def initialize(args = nil)
    if args[0]
      list = gen_list
      @c_list = clean_list(list)
      parse_option(args)
    else
      begin
        raise FlagRequired.new('[mode]', ' is required')
      rescue StandardError => e
        puts e.message
      end
    end
  end

  def invalid_flags
    puts 'Insert a valid flag'
  end

  def prof_error
    puts 'Selected profile does not exist'
  end

  def parse_option(args)
    if %w[-e -c].include?(args[0])
      change_mode(args)
    elsif args[0] == 'help'
      print_help
    else
      invalid_flags
    end
  end

  def change_mode(args)
    if args[1]
      args[0] == '-e' ? change_enforce(args[1]) : change_complain(args[1])
    else
      begin
        raise FlagRequired.new('[name]', ' is required')
      rescue StandardError => e
        puts e.message
      end
    end
  end

  def change_enforce(prof)
    if @c_list.include?(prof)
      `sudo aa-enforce #{prof}`
    else
      puts prof_error
    end
  end

  def change_complain(prof)
    if c_list.include?(prof)
      `sudo aa-complain #{prof}`
    else
      puts prof_error
    end
  end

  def gen_list
    list = `sudo aa-status`
    list.lines.map(&:chomp)
  end

  def get_enforce_count(list)
    list[2].split[0].to_i
  end

  def get_complain_count(list)
    list[@enforce_cnt + 3].split[0].to_i
  end

  def clean_list(list)
    @enforce_cnt = get_enforce_count(list)
    @complain_cnt = get_complain_count(list)
    list.slice!(0..2)
    list.delete_at(@enforce_cnt)
    list.slice!(@enforce_cnt + @complain_cnt..-1)
    list.collect(&:lstrip)
  end

  def print_help
    puts "change_prof <m> [prof]    - change 'prof' in mode
                            specified with 'm'
     -e                   - change in Enforce
     -c                   - change in Complain"
  end

end


