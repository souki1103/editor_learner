require 'diff/lcs'

x = "A lot of money"
y = "A lot of time"

p diffs = Diff::LCS.sdiff(x, y) do |context_change|
 context_change.old_element unless context_change.unchanged?

end 
