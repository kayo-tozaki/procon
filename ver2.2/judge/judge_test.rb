require 'mysql'

class Preparation 
	def startup()	#呼び出し関数
		getDB()		
		getQdata()	
		file_changer()	
	end

	def getDB()		#DBからデータの取得
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
	
	def getQdata()		#問題configからのデータ取得
		f = open("#{$questino_no}", "r")
		num = 1
		f.each_line do |data|
			case num
			when 1
			 $action_sec = data.to_i
			when 2
			 $limit_memory = data.to_i
			when 3
			 $input_times = data.to_i
			when 4
			 $allowable = data.to_i
			end
			num = num + 1
		end
	puts "complete getQdata"
	end
	
	def file_changer()		#操作するファイルのコピーとリネーム
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
	    
	def kind_file() 	#言語ごとのファイル名を返す
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
	def command_language()		#言語ごとのコンパイルコマンドを返す
		return("no compile")	
	end
	
	def compile		#main関数。コンパイルの実行とTLEクラスへのジャンプ。
		command = command_language()
		puts "start_compile command"
		IO.popen(command)
		judge_compile()
	end

	def judge_compile_tle_command	#各言語のclass TLEへの継承先コマンドの記述
		commnand.new.judge_tle		#各言語で継承
	end

	def judge_compile()				#コンパイルができたかの判断とDBの更新
		judge_compile_tle_command()
		size = File.open("../log/#{$time}_compile").size
		if !`cat ../log/#{$time}_compile |grep "warning"`.empty?
	    	puts "warning occured"
	    	$status_code = 23
	     end
		#puts "puts #{size}"
		if( size <= 0 ) then
			$status = 2
			puts "compile complete"
		else
			$status = 21
			puts "compile fail"
		end
		Update_db.new
		# client= Mysql.connect('localhost', 'procon', 'procon', 'submit')
		# query = "update submit.submit_#{Time.now.strftime("%y%m%d")} set status = \'#{$status}\' where post_time = #{$time}"
		# #puts query
		# client.query(query)
		# puts "update database"
		# client.close
	end

end

#class Compileを継承したもの
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

class TLE		#TLE判断。親。
	def get_file_name	#CTLEでのファイル名(grep対応)取得用
		@submit_file_name = Preparation.new.kind_file()
		@submit_file_name[0] = "[#{@submit_file_name[0]}]"
		#puts "submit_file_name is #{@submit_file_name}"
		#example file name "[m]ain.cpp"
	end

	def make_command		#grep用のコマンドの作成。
		get_file_name()
		return("please insert compile command")
	end
	
	def sleep_time
		return 2	#please set wait time (for action_tle)
	end
	
	def status_code
		return 2
	end
	
	def judge_tle		#main関数。TLEのjudgeをし、殺す。
		time = sleep_time()
		sleep time
		command = make_command()
		puts "judge_tle start : #{command}"
		#puts %x(ps alx |grep "#{command}").empty? 
		if (%x(ps alx |grep "#{command}").empty? == true) then
		 $status = status_code()
		 puts "Not action."
		else
		 num = status_code()
		 $status = num*10+2
		 %x(kill `ps alx| grep "#{command}")
		 puts "TLE,kill process"
		end
		puts "after judge_tle, $status is #{$status}"
		Update_db.new
	end
end

#compile TLE の継承
class CTLE_C < TLE
	def make_command
		get_file_name()
		return("g++ #{@submit_file_name} -")
	end
end
class CTLE_Cpp < TLE
	def make_command
		get_file_name()
		return("g++ #{@submit_file_name} -")
	end
end
class CTLE_Java < TLE
	def make_command
		get_file_name()
		return("javac #{@submit_file_name}")
	end
end

class Action 		
  def make_command(times)
    return("Action command")
  end
  
  def action		#main関数
    puts "Start action"
    times = 1
    while times <= $input_times		#テストケースごとに実行する。ログを残すこと。
	    command = make_command(times)
	    input_filename = $questino_no.to_s + "_in_" + times.to_s
	    IO.popen("#{command} < ../compare_file/#{input_filename}.txt > ../log/#{$time}_result 2> ../log/#{$time}_Aerror || echo 'error' > ../log/#{$time}_Aerror ")
	    #TODO:status code 23の時でWAの時の処理
	    judge_tle()
	    size = File.open("../log/#{$time}_Aerror").size
	    if (size > 0)
	    	puts "action Error occured"
	    end
	    
	    #TODO:compare files
	    Compare.new.start

	    times += 1
	 end 
	puts "all problem_num is complete"
	Update_db.new
  end
  
  def judge_tle
  	command.new.judge_tle
  end
end

#Action の継承
class Action_C < Action
	def make_command(times)
		return ("./a.out ") 
	end

	def judge_tle
		ATLE_C.new.judge_tle()
	end
end

class Action_Cpp < Action
	def make_command(times)
		return ("./a.out ") 
	end

	def judge_tle
		ATLE_Cpp.new.judge_tle()
	end
end

class Action_Java < Action
	def make_command(times)
		return ("java Main") 
	end

	def judge_tle
		ATLE_C.new.judge_tle()
	end
end

class Action_Ruby < Action
	def make_command(times)
		return ("./a.out ") 
	end

	def judge_tle
		ATLE_C.new.judge_tle()
	end
end

class ATLE < TLE
	def make_command()
		return("language別コマンド")
	end
	def sleep_time
		return $action_sec
	end
	def status_code
		return 3
	end
end

class ATLE_C < ATLE
	def make_command()
		return("[a].out")
	end
end

class Compare
	def start
		get_answers
		if ($allowable > 0)
			allowable()
		end
		compare

	end
	def get_answers
		count = 0
		@@answer = Array.new
		@@result = Array.new
		File.open("../compare_file/#{$questino_no}_out_#{$input_times}.txt") { |file|
		file.each_line do |val|
				@@answer[count] = val.chomp
				count += 1
			end
	  	}
		count  = 0
		File.open("../log/#{$time}_result") { |file|
			file.each_line do |val|
				@@result[count] = val.chomp
				count += 1
			end
		}
	end
	def allowable
		count = 0
		@@result.each do |value|
			@@result_min = value.split(".")
			@@result_min[1] = @@result_min[1].each_char.each_slice($allowable).map(&:join)
			@@result[count] = @@result_min[0].to_s + "." + @@result_min[1][0].to_s
			count+=1
		end
	end
	def compare
		if tf=(@@result == @@answer) == true
			$status = 4
			puts "get accept, status is #{$status}"
		else
			puts "get wrong answer , status is #{$status}"
			$status = 41
		end
	end
end

class Update_db
	def initialize
		client= Mysql.connect('localhost', 'procon', 'procon', 'submit')
		query = "update submit.submit_#{Time.now.strftime("%y%m%d")} set status = \'#{$status}\' where post_time = #{$time}"
		#puts query
		client.query(query)
		puts "update database"
		client.close
	end
end

#main doing block
Preparation.new.startup()
case $language
when 0
	Compile_C.new.compile()
	Action_C.new.action()
when 1
	Compile_Cpp.new.compile()
when 2
	Compile_Java.new.compile()
end
