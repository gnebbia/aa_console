# Command to search through the audit log file
# all the processes that have tried to execute but
# have been blocked from AppArmor

require 'date'
require '../commands/CLICommand'
require '../commands/font_formatter'

class LogSearchCLICommand < CLICommand
  attr_reader :today

  def initialize(args = nil)
    @today = Date.today.yday
    if args[0]
      parse_option(args)
    else
      no_opt_search
    end
  end

  def puts_err
    puts 'Please select a valid flag'
  end

  def puts_day_error
    puts 'Please provide day number'
  end

  def parse_option(args)
    if %w[-n -d].include?(args[0])
      opt_search(args)
    elsif args[0] == 'help'
      print_help
    else
      puts_err
    end
  end

  def opt_search(args)
    if args[0] == '-d'
      daily_search
    else
      args[1] ? custom_search(args[1].to_i) : puts_day_error
    end
  end

  def daily_search
    s_log = gen_log
    s_log.each do |str|
      tmp_date = str.match(/(?<=audit\()[0-9]+/)
      day = DateTime.strptime(tmp_date.to_s, '%s').yday
      puts str if day == @today
    end
  end

  def custom_search(n_day)
    d_limit = @today - n_day
    s_log = gen_log
    s_log.each do |str|
      tmp_date = str.match(/(?<=audit\()[0-9]+/)
      day = DateTime.strptime(tmp_date.to_s, '%s').yday
      puts str if day >= d_limit
    end
  end

  def gen_log
    log = `grep 'DENIED' /var/log/audit/audit.log`
    log.split("\n")
  end

  def no_opt_search
    system("grep 'DENIED' /var/log/audit/audit.log")
  end

  def print_help
    puts "log_search <flag>         - search for DENIED
                            processes in logs
     -d                   - search on the
                            day's log
     -n [day_#]           - search on the
                            previous N day log"
  end
end
