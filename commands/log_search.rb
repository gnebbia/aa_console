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
      parse_option(args[0])
    else
      no_opt_search
    end
  end

  def puts_err
    puts 'Please select a valid flag'
  end

  def parse_option(flag)
    if %w[-w -d].include?(flag)
      opt_search(flag)
    elsif flag == 'help'
      print_help
    else
      puts_err
    end
  end

  def opt_search(flag)
    daily_search if flag == '-d'
    weekly_search if flag == '-w'
  end

  def daily_search
    s_log = gen_log
    s_log.each do |str|
      tmp_date = str.match(/(?<=audit\()[0-9]+/)
      day = DateTime.strptime(tmp_date.to_s, '%s').yday
      puts str if day == @today
    end
  end

  def weekly_search
    d_limit = @today - 7
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
    puts "log_search <flag>       - search for DENIED
                            processes in logs
     -t                   - search on the
                            day's log
     -w                   - search on the
                            weeks log"
  end
end
