require 'diff/lcs'

f = File.open("que.rb")
s = f.read
f.close
p s

r = File.open("an.rb")
s1 = r.read
r.close
p s1

diffs = Diff::LCS.diff(s,s1)
diffs.each do |diff|
  p diff
end
