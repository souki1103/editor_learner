require 'fileutils'
require 'colorize'
require 'thor'
require "editor_learner/version"

module EditorLearner
class CLI < Thor

    def initialize(*args)
      super
      @prac_dir="#{ENV['HOME']}/editor_learner/workshop"
      if File.exist?(@prac_dir) != true then
        FileUtils.mkdir_p(@prac_dir)
        FileUtils.touch("#{@prac_dir}/question.rb")
        FileUtils.touch("#{@prac_dir}/answer.rb")
      end
      range = 1..6
      range_ruby = 1..3
      range.each{|num|
      if File.exist?("#{@prac_dir}/ruby_#{num}") != true then
          FileUtils.mkdir("#{@prac_dir}/ruby_#{num}")
          FileUtils.touch("#{@prac_dir}/ruby_#{num}/q.rb")
          range_ruby.each{|n|
            FileUtils.touch("#{@prac_dir}/ruby_#{num}/#{n}.rb")
          }
        end
      }
    end

    desc 'delete [number]', 'delete the ruby_file choose number to delete file'

    def delete(n)
      if File.exist?("#{@prac_dir}/ruby_#{n}") == true then
        system "rm -rf #{@prac_dir}/ruby_#{n}"
      end
    end

    desc 'sequential_check [lessen_number] [1~3number] ', 'sequential check your typing skill and edit skill choose number'

    def sequential_check(*argv, n, m)
      l = m.to_i - 1
      @seq_dir = "lib/sequential_check_question"
      puts "check starting ..."
      puts "type following commands on the terminal"
      src_dir = File.expand_path('../..', __FILE__)
      FileUtils.cp(File.join(src_dir, "#{@seq_dir}/ruby_#{n}/#{m}.rb"),  "#{@prac_dir}/ruby_#{n}/q.rb")
      if l != 0 && FileUtils.compare_file("#{@prac_dir}/ruby_#{n}/#{m}.rb", "#{@prac_dir}/ruby_#{n}/q.rb") != true
        FileUtils.compare_file("#{@prac_dir}/ruby_#{n}/#{l}.rb", (File.join(src_dir, "#{@seq_dir}/ruby_#{n}/#{l}.rb"))) == true
        FileUtils.cp("#{@prac_dir}/ruby_#{n}/#{l}.rb", "#{@prac_dir}/ruby_#{n}/#{m}.rb")
      end

      if FileUtils.compare_file("#{@prac_dir}/ruby_#{n}/#{m}.rb", "#{@prac_dir}/ruby_#{n}/q.rb") != true then
        open_terminal
        loop do
          sleep(1)
          if File.exist?("#{@prac_dir}/ruby_#{n}/#{m}.rb") && File.exist?("{@prac_dir}/ruby_#{n}/q.rb") then
            sleep(1)
            if FileUtils.compare_file("#{prac_dir}/ruby_#{n}/#{m}.rb", "#{prac_dir}/ruby_#{n}/q.rb") == true then
              puts "ruby_#{n}/#{m}.rb is don!"
              break
            end
          end
        end
      end
      puts "ruby_#{n}/#{m}.rb is done!"
    end

    desc 'random_check', 'ramdom check your typing and edit skill.'

    def random_check(*argv)
      random = rand(1..4)
      p random
      s = "#{random}.rb"
      puts "check starting ..."
      puts "type following commands on the terminal"
      puts "> emacs question.rb answer.rb"

      src_dir = File.expand_path('../..', __FILE__) # "Users/souki/editor_learner"

      FileUtils.cp(File.join(src_dir, "lib/question/test/#{s}"), "#{@prac_dir}/question.rb")
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
