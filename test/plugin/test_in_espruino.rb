require 'fluent/test'

class EspruinoInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    require 'fluent/plugin/in_espruino'
  end

  CONFIG = %[
    type espruino
    com_port serial
    baud_rate 9600
    tag espruino
    format /\d+,\d+,\d+(.\d+)/
  ]

  def create_driver(conf=CONFIG)
    Fluent::Test::InputTestDriver.new(Fluent::EspruinoInput).configure(conf)
  end

  def test_configure_test_driver
    d = create_driver
    assert_equal 'serial', d.instance.com_port
    assert_equal 9600, d.instance.baud_rate
    assert_equal 'espruino', d.instance.tag
  end
end
