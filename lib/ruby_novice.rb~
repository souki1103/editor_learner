require 'fileutils'
require 'colorize'
require 'thor'

module RubyNovice
  class CLI < Thor

    def initialize(*args)
      super
      @prac_dir="#{ENV['HOME']}/.editor_learner"
      if File.exist?(@prac_dir) != true then
        FileUtils.mkdir_p(@prac_dir)
        FileUtils.touch("#{@prac_dir}/question.rb")
        FileUtils.touch("#{@prac_dir}/answer.rb")
      end
    end

    desc 'random_check', 'ramdom check your typing and edit skill.'
#        def sequntial_check(*argv)
    def random_check(*argv)
      random = rand(4..8)
      p random
      s = "#{random}.rb"
      puts "check starting ..."
      puts "type following commands on the terminal"
      puts "> emacs question.rb answer.rb"

      src_dir = File.expand_path('../..', __FILE__) # "Users/souki/editor_learner"

      FileUtils.cp(File.join(src_dir, "lib/question/ruby_1/#{s}"), "#{@prac_dir}/question.rb")
      open_terminal

      start_time = Time.now
      loop do
        sleep(1)
        if File.exist?("#{@prac_dir}/question.rb") && File.exist?("#{@prac_dir}/answer.rb") then
          if FileUtils.compare_file("#{@prac_dir}/question.rb", "#{@prac_dir}/answer.rb") == true then
            break
          end
        end
      end
      end_time = Time.now
      time = end_time - start_time - 1

      puts "#{time} sec"
    end

    no_commands do
      def open_terminal
        pwd = Dir.pwd
        system "osascript -e 'tell application \"Terminal\" to do script \"cd #{@prac_dir} \" '"
      end
    end
  end
end
