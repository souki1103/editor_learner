require 'fileutils'

module RubyNovice
random = rand(1..4)
 s = %(#{random}.rb)

 FileUtils.cp("mondai/#{s}", "question.rb")
p random

start_time = Time.now
loop do
  sleep(1)
  if File.exist?("question.rb") && File.exist?("answer.rb")
    if FileUtils.compare_file("question.rb", "answer.rb") == true
      break
    end
  end

end
end_time = Time.now
time = end_time - start_time - 1

 puts "#{time} sec"
end
