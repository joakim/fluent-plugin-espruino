module Fluent
class EspruinoInput < Input
  Plugin.register_input('espruino', self)
  config_param :com_port, :string
  config_param :baud_rate, :integer
  config_param :tag, :string, :default => "espruino"
  config_param :eol, :string, :default => $/

  def initialize
    require 'serialport'
    super
  end

  def configure(conf)
    super
    @device = device
  end

  def start
    @serial = SerialPort.new(@com_port, @baud_rate, 8, 1, SerialPort::NONE)
    @serial.write("echo(0)")
    @thread = Thread.new(&method(:run))
  end

  def shutdown
    @serial.write("echo(1)")
    @serial.close
    @thread.join
  end

  def run
    loop do
      unless @serial.closed?
        begin
          data = JSON.parse(@serial.readline(@eol))
          Engine.emit(@tag, Engine.now, data)
        rescue
          STDERR.puts caller()
          break
        end
      end
    end
  end

  private
  def device
    File.basename(@com_port).gsub(/\./,"_")
  end
end
end
