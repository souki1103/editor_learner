require 'fileutils'
require 'el_methods.rb'

class TypingPractice

   def initialize(prac_dir: String, origin_dir: String)
    @prac_dir = prac_dir
    @origin_dir = origin_dir
  end
  def prac_sequence(origin_file: String)
    instruct_print
    cp_file(origin_file: origin_file, clone_file: "#{@prac_dir}/question.rb")
    open_terminal(init_dir: @prac_dir)
    start_time = Time.now
    typing_discriminant(answer_path: "#{@prac_dir}/answer.rb", question_path: "#{@prac_dir}/question.rb")
    time_check(start_time: start_time)
  end
end
