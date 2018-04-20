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
      init_exist_files(inject_dir: "#{@inject}", prac_dir: "#{@prac_dir}", command_type: "random")
      range_ruby_dir = 1..6
      range_ruby_file = 1..3
      range_ruby_dir.each do |dir_num|
        init_exist_files(inject_dir: "#{@inject}", prac_dir: "#{@prac_dir}/ruby_#{dir_num}", command_type: "sequential")
        if Dir.empty?("#{@prac_dir}/ruby_#{dir_num}") == true then
          range_ruby_file.each do |file_num|
            FileUtils.touch("#{@prac_dir}/ruby_#{dir_num}/#{file_num}.rb")
          end
        end
      end
    end
    
    desc 'delete [number~number]', 'delete the ruby_file choose number to delete file'
    def delete(n, m)
      range = n..m
      range.each do |num|
        if File.exist?("#{@prac_dir}/ruby_#{num}") == true then
          system "rm -rf #{@prac_dir}/ruby_#{num}"
        end
      end
    end

    desc 'sequential_check [lesson_number1~6] [number1~3] ','sequential check your typing skill and edit skill choose number'
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
