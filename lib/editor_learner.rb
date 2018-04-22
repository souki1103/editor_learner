require 'fileutils'
require 'colorize'
require 'thor'
require 'editor_learner/version'
require 'diff-lcs'
require 'open3'
require 'el_methods.rb'
require 'el_sub_class.rb'

module EditorLearner
  # editor_learner CLI main class
  class CLI < Thor
    def initialize(*args)
      super
      # el is editor_learner
      @el_prac_dir = "#{ENV['HOME']}/editor_learner/workshop"
      @gem_locations = Open3.capture3('gem environment gemdir')
      app_vers = Open3.capture3('gem list editor_learner')
      @el_ver = app_vers[0].chomp.tr(' ', '-').delete('()')
      @el_origin_dir = File.join(@gem_locations[0].chomp, "/gems/#{@el_ver}")
      init_mk_files(origin_dir: @el_origin_dir, prac_dir: @el_prac_dir)
    end

    desc 'delete [number~number]', 'choose number to delete ruby_files'
    def delete(head_num, end_num)
      range = head_num..end_num
      range.each do |num|
        if File.exist?("#{@el_prac_dir}/ruby_#{num}") == true
          system "rm -rf #{@el_prac_dir}/ruby_#{num}"
        end
      end
    end

    desc 'sequential_check [dir_num:1~6] [file_num:1~3] ', 'typing and editing practice.'
    def sequential_check(*_argv, dir_num, file_num)
      origin_seq_dir = "#{@el_origin_dir}/lib/sequential_check_question"
      origin_file_path = "#{origin_seq_dir}/ruby_#{dir_num}/#{file_num}.rb"
      typing_prac_class = TypingPractice.new(prac_dir: @el_prac_dir, origin_dir: @el_origin_dir)
      typing_prac_class.prac_sequence(origin_file: origin_file_path)
    end

    desc 'random_check', 'typing and editing practice.'
    def random_check(*_argv)
      origin_rand_dir = "#{@el_origin_dir}/lib/random_check_question"
      rand_num = rand(1..15)
      origin_rand_file = "#{origin_rand_dir}/#{rand_num}.rb"
      FileUtils.cp('/dev/null', "#{@el_prac_dir}/answer.rb")
      typing_prac_class = TypingPractice.new(prac_dir: @el_prac_dir, origin_dir: @el_origin_dir)
      typing_prac_class.prac_sequence(origin_file: origin_rand_file)
    end

    no_commands do
      def output_training_data
      end
    end
  end
end
