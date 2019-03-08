class FlagRequired < StandardError

  def initialize (flag, message)
    err_msg = 'Check arguments: ' + flag + message
    super(err_msg)
  end
end