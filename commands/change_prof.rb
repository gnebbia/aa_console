require '../commands/CLICommand'

class ChangeProfCLICommand < CLICommand
  attr_reader :c_list

  def initialize(args = nil)
    if args[0]
      list = gen_list
      @c_list = clean_list(list)
      parse_option(args)
    else
      puts_err
    end
  end

  def puts_err
    puts '[mode] is required'
  end

  def invalid_flags
    puts 'Insert a valid flag'
  end

  def missing_args
    puts 'Please provide a profile name'
  end

  def prof_error
    puts 'Selected profile does not exist'
  end

  # @todo aggiungere print help
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
    missing_args unless args[1]
    if args[0] == '-e'
      change_enforce(args[1])
    else
      change_complain(args[1])
    end
  end

  def change_enforce(prof)
    if @c_list.include?(prof.to_s)
      "sudo aa-enforce#{prof}"
    else
      puts prof_error
    end
  end

  def change_complain(prof)
    if c_list.include?(prof.to_s)
      "sudo aa-complain #{prof}"
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
    list
  end

  def print_help
    puts "change_prof <m> [prof]    - change 'prof' in mode
                            specified with 'm'
     -e                   - change in Enforce
     -c                   - change in Complain"
  end

end


