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

def instruct_print
  puts "check starting ..."
  puts "type following commands on the terminal"
  puts "> emacs question.rb answer.rb"
end
