require 'fileutils'
require 'colorize'
require 'thor'

module RubyNovice
  class CLI < Thor

  desc 'check', 'check your typing skill.'
  def check(*argv)    
    random = rand(1..4)
    s = %(#{random}.rb)
    
    FileUtils.cp("/Users/souki/editor_learner/lib/mondai/#{s}", "question.rb")
    p random
    open
    
    start_time = Time.now
    loop do
      sleep(1)
      if File.exist?("/Users/souki/editor_learner/lib/question.rb") && File.exist?("/Users/souki/editor_learner/lib/answer.rb") then
        if FileUtils.compare_file("/Users/souki/editor_learner/lib/question.rb", "/Users/souki/editor_learner/lib/answer.rb") == true then
          break
        end
      end
    end
    end_time = Time.now
    time = end_time - start_time - 1
    
    puts "#{time} sec"
  end
  no_commands do
    def open
      pwd = Dir.pwd
      system "osascript -e 'tell application \"Terminal\" to do script \"cd #{pwd} \" '"
    end
  end
end
end
