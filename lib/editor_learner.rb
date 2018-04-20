# coding: utf-8
require 'fileutils'
require 'colorize'
require 'thor'
require "editor_learner/version"
require 'diff-lcs'
require "open3"


module EditorLearner
  class CLI < Thor

    def initialize(*args)
      super
      @prac_dir="#{ENV['HOME']}/editor_learner/workshop"
      @lib_location = Open3.capture3("gem environment gemdir")
      @versions = Open3.capture3("gem list editor_learner")
      p @latest_version = @versions[0].chomp.gsub(' (', '-').gsub(')','')
      @inject = File.join(@lib_location[0].chomp, "/gems/#{@latest_version}/lib")
      if File.exist?(@prac_dir) != true then
        FileUtils.mkdir_p(@prac_dir)
        FileUtils.touch("#{@prac_dir}/question.rb")
        FileUtils.touch("#{@prac_dir}/answer.rb")
        FileUtils.touch("#{@prac_dir}/random_h.rb")
        if File.exist?("#{@inject}/random_h.rb") == true then
          FileUtils.cp("#{@inject}/random_h.rb", "#{@prac_dir}/random_h.rb")
        elsif
          FileUtils.cp("#{ENV['HOME']}/editor_learner/lib/random_h.rb", "#{@prac_dir}/random_h.rb")
        end
      end
      range = 1..6
      range_ruby = 1..3
      range.each do|num|
        if File.exist?("#{@prac_dir}/ruby_#{num}") != true then
          FileUtils.mkdir("#{@prac_dir}/ruby_#{num}")
          FileUtils.touch("#{@prac_dir}/ruby_#{num}/question.rb")
          FileUtils.touch("#{@prac_dir}/ruby_#{num}/answer.rb")
          FileUtils.touch("#{@prac_dir}/ruby_#{num}/sequential_h.rb")
          if File.exist?("#{@inject}/sequential_h.rb") == true then
            FileUtils.cp("#{@inject}/sequential_h.rb", "#{@prac_dir}/ruby_#{num}/sequential_h.rb")
          else
            FileUtils.cp("#{ENV['HOME']}/editor_learner/lib/sequential_h.rb", "#{@prac_dir}/ruby_#{num}/sequential_h.rb")
          end
          range_ruby.each do|n|
            FileUtils.touch("#{@prac_dir}/ruby_#{num}/#{n}.rb")
          end
        end
      end
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

    desc 'sequential_check [lesson_number] [1~3number] ','sequential check your typing skill and edit skill choose number'
    def sequential_check(*argv, n, m)
      puts "check starting ..."
      puts "type following commands on the terminal"
      puts "> emacs question.rb answer.rb"
      check_and_cp_file(inject_dir: "#{@inject}/sequential_check_question/ruby_#{n}", prac_dir: "#{@prac_dir}/ruby_#{n}", prac_file: "#{m}.rb", command_type: "sequential")
      open_terminal(present_dir: "#{@prac_dir}/ruby_#{n}")
      start_time = Time.now
      typing_discriminant(file_path_answer: "#{@prac_dir}/ruby_#{n}/answer.rb", file_path_question: "#{@prac_dir}/ruby_#{n}/question.rb")
      time_check(start_time: start_time)
      p "ruby_#{n}/#{m}.rb is finished!"
    end

    desc 'random_check', 'ramdom check your typing and edit skill.'
    def random_check(*argv)
      random = rand(1..15)
      prac_file = "#{random}.rb"
      puts "check starting ..."
      puts "type following commands on the terminal"
      puts "> emacs question.rb answer.rb"
      check_and_cp_file(inject_dir: "#{@inject}/random_check_question", prac_dir: "#{@prac_dir}", prac_file: prac_file, command_type: "random")
      FileUtils.cp("/dev/null", "#{@prac_dir}/answer.rb")
      open_terminal(present_dir: "#{@prac_dir}")
      start_time = Time.now
      typing_discriminant(file_path_answer: "#{@prac_dir}/answer.rb", file_path_question: "#{@prac_dir}/question.rb")
      time_check(start_time: start_time)
    end

    no_commands do
      def open_terminal(present_dir: String)
        pwd = Dir.pwd
        system "osascript -e 'tell application \"Terminal\" to do script \"cd #{present_dir} \" '"
      end
      def spell_diff_check(file_path_answer: String, file_path_question: String)
        stdin, stdout, stderr = Open3.popen3("diff -c #{file_path_answer} #{file_path_question}")
        stdout.each do |diff|
          p diff.chomp
        end
      end
      def time_check(start_time: Time)
        end_time = Time.now
        elapsed_time = end_time - start_time - 1
        puts "#{elapsed_time} sec"
      end
      def typing_discriminant(file_path_answer: String, file_path_question: String)
        loop do
          puts "If you complete typing, press return-key"
          input = STDIN.gets
          if FileUtils.compare_file("#{file_path_answer}", "#{file_path_question}") == true then
            puts "It have been finished!"
            break
          else
            puts "There are some differences"
            spell_diff_check(file_path_answer: "#{file_path_answer}", file_path_question: "#{file_path_question}")
          end
        end
      end
      def check_and_cp_file(inject_dir: String, prac_dir: String, prac_file: String, command_type: String)
        src_dir = File.expand_path('../..', __FILE__) # dir is where you make clone
        if File.exist?("#{inject_dir}/#{prac_file}") == true then
          FileUtils.cp("#{inject_dir}/#{prac_file}", "#{prac_dir}/question.rb")
        else
          FileUtils.cp(File.join(src_dir, "lib/#{command_type}_check_question/#{prac_file}"),  "#{prac_dir}/question.rb")
        end
      end
    end

  end
end
