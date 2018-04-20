# coding: utf-8
require 'fileutils'
require 'colorize'
require 'thor'
require "editor_learner/version"
require 'diff-lcs'
require "open3"
require  './lib/editor_learner_method.rb'

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
    def sequential_check(*argv, dir_num, file_num)
      inject_dir_seq = "#{@inject}/sequential_check_question/ruby_#{dir_num}"
      prac_dir_seq = "#{@prac_dir}/ruby_#{dir_num}"
      instruct_print
      check_and_cp_file(inject_dir: inject_dir_seq, prac_dir: prac_dir_seq, prac_file: "#{file_num}.rb", command_type: "sequential")
      open_terminal(present_dir: prac_dir_seq)
      start_time = Time.now
      typing_discriminant(file_path_answer: "#{prac_dir_seq}/answer.rb", file_path_question: "#{prac_dir_seq}/question.rb")
      time_check(start_time: start_time)
      p "ruby_#{dir_num}/#{file_num}.rb is finished!"
    end

    desc 'random_check', 'ramdom check your typing and edit skill.'
    def random_check(*argv)
      inject_dir_rand = "#{@inject}/random_check_question"
      random = rand(1..15)
      prac_file = "#{random}.rb"
      instruct_print
      check_and_cp_file(inject_dir: inject_dir_rand, prac_dir: "#{@prac_dir}", prac_file: prac_file, command_type: "random")
      FileUtils.cp("/dev/null", "#{@prac_dir}/answer.rb")
      open_terminal(present_dir: "#{@prac_dir}")
      start_time = Time.now
      typing_discriminant(file_path_answer: "#{@prac_dir}/answer.rb", file_path_question: "#{@prac_dir}/question.rb")
      time_check(start_time: start_time)
    end

  end
end
