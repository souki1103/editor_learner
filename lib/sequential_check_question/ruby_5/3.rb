require 'minitest/autorun'

class ConvertHashSyntaxTest < Minitest::Test
  def test_convert_hash_syntax
    old_syntax = <<~TEXT
    {
      :name => 'Alice'
      :age => 20,
      :gender => :female
    }
    TEXT
    expected = <<~TEXT
    {
      name: 'Alice'
      age: 20,
      gender: :female
    }
    TEXT
    actual = convert_hash_syntax(old_syntax)
    puts actual
    assert_equal expected, actual
  end
end

def convert_hash_syntax(old_syntax)
  old_syntax.gsub(/:(w+) *=> */, '\1: ')
end
