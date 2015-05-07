require 'mysql'

class Preparation 
	def startup()
		getDB()
		getQdata()
		file_changer()
	end
	def getDB()
		day = Time.now.strftime("%y%m%d")
		client= Mysql.connect('localhost', 'procon', 'procon', 'submit')
		client.query("SELECT * FROM submit.submit_#{day} order by post_time desc").each do |post_time,team_name ,problem_num,language,status|  # テスト用にDesc入ってるので注意
		  $time = post_time.to_i
		  $team_name = team_name
		  $questino_no = problem_num.to_i
		  $language = language.to_i
		  $status = status.to_i 
		  break
		end
		puts "complete getDB"
		client.close
	end
	def getQdata()
		f = open("#{$questino_no}", "r")
		num = 1
		f.each_line do |data|
			case num
			when 1
			 $action_sec = data
			when 2
			 $limit_memory = data
			when 3
			 $input_times = data
			when 4
			 $allowable = data
			end
			num = num + 1
		end
	puts "complete getQdata"
	end
	
  def file_changer()
      file_name = kind_file()
      if File.exist?(file_name)
        IO.popen("rm -rf #{file_name}")
      end
      command = %Q(cp ../submit_file/#{$time} #{file_name})
      IO.popen(command)
      sleep 0.01
      if File.exist?(file_name)
        puts "complete filename_changer"
      else
        puts "cannot change file_name"
      end
   end
    
	def kind_file()
		case $language
		when 0
			return("main.c")
		when 1
			return("main.cpp")
		when 2
			return("Main.java")
		when 3
			return("main.rb")
		when 4
			return("main.py")
		when 5
			return("main.py")
		else
			return("error,not data")
		end
	end
end

class Compile 
	def command_language()
		return("no compile")		#コンパイル時のコマンドを記述
	end
	def compile
		command = command_language()
		puts "start_compile command"
		IO.popen(command)
		judge_tle()
	end
	def judge_compile_tle_command
		commnand.new.judge_tle
	end

	def judge_tle()
		judge_compile_tle_command()
		size = File.open("../log/#{$time}_compile").size
		puts "puts #{size}"
		if( size <= 0 ) then
			$status = 2
			puts "compile complete"
		else
			$status = 21
			puts "compile fail"
		end
		client= Mysql.connect('localhost', 'procon', 'procon', 'submit')
		query = "update submit.submit_#{Time.now.strftime("%y%m%d")} set status = \'#{$status}\' where post_time = #{$time}"
		#puts query
		client.query(query)
		puts "update database"
		client.close
	end

end
#以下、継承したもの。
class Compile_C < Compile
	def command_language()
		return("g++ main.c 2> ../log/#{$time}_compile")
	end	
	def judge_compile_tle_command
		CTLE_C.new.judge_tle()
	end
end
class Compile_Cpp < Compile
	def command_language()
		return("g++ main.cpp -std=c++11 2> ../log/#{$time}_compile")
	end	
	def judge_compile_tle_command
		CTLE_Cpp.new.judge_tle
	end
end
class Compile_Java < Compile
	def command_language()
		return("/usr/local/src/jdk1.8.0_40/bin/javac Main.java 2> ../log/#{time}_compile")
	end	
	def judge_compile_tle_command
		CTLE_Java.new.judge_tle
	end
end

class TLE

	def get_file_name
		@submit_file_name = Preparation.new.kind_file()
		@submit_file_name[0] = "[#{@submit_file_name[0]}]"
		#puts "submit_file_name is #{@submit_file_name}"
	end
	def make_command
		get_file_name()
		return("please insert compile command")
	end
	def judge_tle
		sleep 2
		command = make_comand()
		puts "judge_tle start : #{command}"
		#puts %x(ps alx |grep "#{command}").empty? 
		if (%x(ps alx |grep "#{command}").empty? == true) then
		 $status = 2 
		 puts "compile is complete."
		else
		 $status = 22 
		 %x(kill `ps alx| grep "#{command}")
		 puts "TLE,kill process"
		end
		puts "after judge_tle, $status is #{$status}"
	end
end
#TLE の継承（コンパイル）。
class CTLE_C < TLE
	def make_comand
		get_file_name()
		return("g++ #{@submit_file_name} -")
	end
end
class CTLE_Cpp < TLE
	def make_comand
		get_file_name()
		return("g++ #{@submit_file_name} -")
	end
end
class CTLE_Java < TLE
	def make_comand
		get_file_name()
		return("javac #{@submit_file_name}")
	end
end

class Action 
  def make_command
    return("Action command")
  end
  
  def action
    puts "Start action"
    command = make_comamnd()
   #Rubyの実行
    
  end
end

Preparation.new.startup()
case $language
when 0
	Compile_C.new.compile()
when 1
	Compile_Cpp.new.compile()
when 2
	Compile_Java.new.compile()
end
