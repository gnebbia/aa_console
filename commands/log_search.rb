# Command to search through the audit log file
# all the processes that have tried to execute but
# have been blocked from AppArmor

require 'date'
require_relative 'CLICommand'
require_relative 'font_formatter'
require '../exceptions/FlagRequired'

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
      check_args(args)
    end
  end

  def check_args(args)
    if args[1]
      custom_search(args[1].to_i)
    else
      begin
        raise FlagRequired.new('[day-number]', ' is required')
      rescue StandardError => e
        puts e.message
      end
    end
  end

  def daily_search
    s_log = gen_log
    s_log.each do |str|
      tmp = parse_log(str)
      if tmp[1].yday == @today
        puts "PROC: #{tmp[0]}\tDATE: #{tmp[1]}\tOP: #{tmp[2]}\tCMD: #{tmp[3]}"
      end
    end
  end

  def custom_search(n_day)
    d_limit = @today - n_day
    s_log = gen_log
    s_log.each do |str|
      tmp = parse_log(str)
      if tmp[1].yday >= d_limit
        puts "PROC: #{tmp[0]}\tDATE: #{tmp[1]}\tOP: #{tmp[2]}\tCMD: #{tmp[3]}"
      end
    end
  end

  def parse_log(str)
    proc = str.match(/(?<=profile\=\")[a-zA-Z\/+\-+\.+]+/)
    op = str.match(/(?<=operation\=\")[a-zA-Z\/+\-+\.+]+/)
    cmd = str.match(/(?<=comm\=\")[a-zA-Z\/+\-+\.+]+/)
    tmp_date = str.match(/(?<=audit\()[0-9]+/)
    date = DateTime.strptime(tmp_date.to_s, '%s').to_date
    [proc, date, op, cmd]
  end

  def gen_log
    log = `grep 'DENIED' /var/log/audit/audit.log`
    log.split("\n")
  end

  def no_opt_search
    s_log = gen_log
    s_log.each do |str|
      tmp = parse_log(str)
      puts "PROC: #{tmp[0]}\tDATE: #{tmp[1]}\tOP: #{tmp[2]}\tCMD: #{tmp[3]}"
    end
  end

  def print_help
    puts "log_search <flag>         - search for DENIED
                            processes in logs
     -d                   - search on the
                            day's log
     -n [day_#]           - search on the
                            previous N days log"
  end
end
