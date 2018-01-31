require 'fileutils'
require 'colorize'
require 'thor'
require "editor_learner/version"
require 'diff-lcs'

module EditorLearner
class CLI < Thor

    def initialize(*args)
      super
      @prac_dir="#{ENV['HOME']}/editor_learner/workshop"
      if File.exist?(@prac_dir) != true then
        FileUtils.mkdir_p(@prac_dir)
        FileUtils.touch("#{@prac_dir}/question.rb")
        FileUtils.touch("#{@prac_dir}/answer.rb")
        FileUtils.touch("#{@prac_dir}/random_h.rb")
        FileUtils.cp("#{ENV['HOME']}/editor_learner/lib/random_h.rb", "#{@prac_dir}/random_h.rb")
      end
      range = 1..6
      range_ruby = 1..3
      range.each{|num|
      if File.exist?("#{@prac_dir}/ruby_#{num}") != true then
          FileUtils.mkdir("#{@prac_dir}/ruby_#{num}")
          FileUtils.touch("#{@prac_dir}/ruby_#{num}/q.rb")
          FileUtils.touch("#{@prac_dir}/ruby_#{num}/sequential_h.rb")
          FileUtils.cp("#{ENV['HOME']}/editor_learner/lib/sequential_h.rb", "#{@prac_dir}/ruby_#{num}/sequential_h.rb")
          range_ruby.each{|n|
            FileUtils.touch("#{@prac_dir}/ruby_#{num}/#{n}.rb")
          }
        end
      }
    end

    desc 'delete [number~number]', 'delete the ruby_file choose number to delete file'

    def delete(n, m)
      range = n..m
      range.each{|num|
      if File.exist?("#{@prac_dir}/ruby_#{num}") == true then
        system "rm -rf #{@prac_dir}/ruby_#{num}"
      end
      }
    end

    desc 'sequential_check [lessen_number] [1~3number] ','sequential check your typing skill and edit skill choose number'
    def sequential_check(*argv, n, m)
      l = m.to_i - 1
      @seq_dir = "lib/sequential_check_question"
      q_rb = "ruby_#{n}/#{m}.rb"
      @seqnm_dir = File.join(@seq_dir,q_rb)
      @pracnm_dir = "#{ENV['HOME']}/editor_learner/workshop/ruby_#{n}/#{m}.rb"
      @seqnq_dir = "lib/sequential_check_question/ruby_#{n}/q.rb"
      @pracnq_dir = "#{ENV['HOME']}/editor_learner/workshop/ruby_#{n}/q.rb"      
      @seqnl_dir = "lib/sequential_check_question/ruby_#{n}/#{l}.rb"
      @pracnl_dir = "#{ENV['HOME']}/editor_learner/workshop/ruby_#{n}/#{l}.rb"      
      puts "check starting ..."
      puts "type following commands on the terminal"
      src_dir = File.expand_path('../..', __FILE__)
      FileUtils.cp(File.join(src_dir, "#{@seqnm_dir}"),  "#{@pracnq_dir}")
      if l != 0 && FileUtils.compare_file("#{@pracnm_dir}", "#{@pracnq_dir}") != true
        FileUtils.compare_file("#{@pracnl_dir}", (File.join(src_dir, "#{@seqnl_dir}"))) == true
        FileUtils.cp("#{@pracnl_dir}", "#{@pracnm_dir}")
      end
      
      if FileUtils.compare_file(@pracnm_dir, @pracnq_dir) != true then
        system "osascript -e 'tell application \"Terminal\" to do script \"cd #{@prac_dir}/ruby_#{n} \" '"
        loop do
          a = STDIN.gets.chomp
          if a == "check" && FileUtils.compare_file("#{@pracnm_dir}", "#{@pracnq_dir}") == true then
            puts "ruby_#{n}/#{m}.rb is done!"
            break
          elsif FileUtils.compare_file("#{@pracnm_dir}", "#{@pracnq_dir}") != true then
            @inputdata = File.open("#{@pracnm_dir}").readlines
            @checkdata = File.open("#{@pracnq_dir}").readlines
            diffs = Diff::LCS.diff("#{@inputdata}", "#{@checkdata}")
            diffs.each do |diff|
              p diff
            end
          end
        end
       else
        p "ruby_#{n}/#{m}.rb is finished!"
      end
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

      FileUtils.cp(File.join(src_dir, "lib/random_check_question//#{s}"), "#{@prac_dir}/question.rb")
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
