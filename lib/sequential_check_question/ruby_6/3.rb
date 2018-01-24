require 'minitest/autorun'

class GateTest < Minitest::Test
  def setup
    @umeda = Gate.new(:umeda)
    @juso = Gate.new(:juso)
    @mikuri = Gate.new(:mikuri)
  end

  def test_umeda_to_juso
    ticket = Ticket.new(150)
    @umeda.enter(ticket)
    assert @juso.exit(ticket)
  end
end

class Gate
  def initialize(name)
    @name = name
  end

  def enter(ticket)
  end

  def exit(ticket)
    true
  end
end

class Ticket
  def initialize(fare)
    @fare = fare
  end
end
