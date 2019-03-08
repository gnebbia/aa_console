class CommandNotFound < StandardError

  def initialize(command, message)
    err_msg = 'ERROR: ' + command + message
    super(err_msg)
  end
end