equire 'minitest/autorun'

class ConvertHashSyntaxTest < Minitest::Test
  def test_convert_hash_syntax
    assert_equal '{}', convert_hash_syntax('{}')
  end
end

old_syntax = <<TEXT                                                                                                                    
{                                                                                                                                      
  :name => 'Alice'                                                                                                                     
  :age => 20,                                                                                                                          
  :gender => female                                                                                                                    
}                                                                                                                                      
TEXT                                                                                                                                   
def convert_hash_syntax(old_syntax)
  old_syntax
