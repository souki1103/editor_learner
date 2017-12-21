require 'diff/lcs'
require 'color_echo'

def text_diff (one, another, verbose=false)
  diff_text=Diff::LCS.sdiff(one.split(//u), another.split(//u))
  #  diff_text=Diff::LCS.sdiff(one, another)
  cont,add,del="","",""
  state=''
  count=0
  diff_text.each {|text|
    p text if verbose
    if state!=text.action then #out
      case state
      when '='
      when '-'; cont << del+"\'\}\}"
      when '+'; cont << add+"\',red\}\}"
      when '!'
        cont << del+"\'\}\}"
        cont << add+"\',red\}\}"
        count +=1
      end
      state,del,add = text.action,"\{\{fontd \'","\{\{fontc \'"
    end
    case text.action #in
    when '=';    cont << text.old_element
    when '-';    del << text.old_element
    when '+';    add << text.new_element
    when '!'
      del << text.old_element
      add << text.new_element
    end
  }
  cont << del+"\'\}\}"
  cont << add+"\',red\}\}"

  return [cont,count]
end

text_a = "A lot of money"
text_b = "A lot of time"

text = text_diff(text_a, text_b, verbose=true)
CE.fg(:gray).pickup(/\{\{(.+?)\}\}/,:red)
puts text[0]
