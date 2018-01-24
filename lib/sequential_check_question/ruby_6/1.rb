require 'minitest/autorun'

class GateTest < Minitest::Test
  def test_gate
    assert Gate.new
  end
end

class Gate
end
