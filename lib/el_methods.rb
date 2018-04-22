def open_terminal(init_dir: String)
  system "osascript -e 'tell application \"Terminal\" to do script \"cd #{init_dir} \" '"
end

def spell_diff_check(file1: String, file2: String)
  stdin, stdout, stderr = Open3.popen3("diff -c #{file1} #{file2}")
  stdout.each do |diff|
    p diff.chomp
  end
end

def time_check(start_time: Time)
  end_time = Time.now
  elapsed_time = end_time - start_time - 1
  puts "#{elapsed_time} sec"
end

def typing_discriminant(answer_path: String, question_path: String)
  loop do
    puts "If you complete typing, press return-key"
    input = STDIN.gets
    if FileUtils.compare_file("#{answer_path}", "#{question_path}") == true then
      puts "It have been finished!"
      break
    else
      puts "There are some differences"
      spell_diff_check(file1: "#{answer_path}", file2: "#{question_path}")
    end
  end
end

def cp_file(origin_file: String, clone_file: String)
  FileUtils.cp("#{origin_file}",  "#{clone_file}")
end

def instruct_print
  puts "check starting ..."
  puts "type following commands on the terminal"
  puts "> emacs question.rb answer.rb"
end

def init_mk_files(origin_dir: String, prac_dir: String)
  if File.exist?(prac_dir) != true then
    FileUtils.mkdir_p(prac_dir)
    system("cp -R #{origin_dir}/workshop/* #{prac_dir}")
  end
end

def get_app_ver(app_name: String)
  app_vers = Open3.capture3("gem list #{app_name}")
  latest_ver = app_vers[0].chomp.gsub(' (', '-').gsub(')','')
  return latest_ver
end
