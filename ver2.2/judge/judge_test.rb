
require 'mysql'

class Preparation 
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
			exit()
		end
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

	def startup()	#呼び出し関数
		getDB()		
		getQdata()	
		file_changer()	
	end
end

class Compile 
	def command_language()		#言語ごとのコンパイルコマンドを返す
		return("no compile")	
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
	end
	def compile		#main関数。コンパイルの実行とTLEクラスへのジャンプ。
		command = command_language()
		puts "start_compile command"
		IO.popen(command)
		judge_compile()
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
	def sleep_time
		return 2	#please set wait time (for action_tle)
	end
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
	def status_code
		return 2
	end
	def judge_tle		#main関数。TLEのjudgeをし、殺す。
		time = sleep_time()
		sleep time
		command = make_command()
		puts "judge_tle start : #{command}"
		puts %x(ps alx |grep "#{command}").empty? 
		
		if (%x(ps alx |grep "#{command}").empty? == true) then
		 $status = status_code()
		 puts "Not action."
		else
		 num = status_code()
		 $status = num*10+2
		 Update_db.new
		 puts "TLE,kill process status is #{$status}"
		 Process.kill('KILL',$io.pid)
		 IO.popen("ruby killer.rb")	#terminated
		 exit()
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
  def judge_tle
  	command.new.judge_tle
  end  
  def action		#main関数
    puts "Start action"
    times = 1
    return_words = ""
    while times <= $input_times		#テストケースごとに実行する。ログを残すこと。
	    command = make_command(times)
	    input_filename = $questino_no.to_s + "_in_" + times.to_s
	   	$io = IO.popen("#{command} < ../compare_file/#{input_filename}.txt ")
	   	judge_tle()
	   	IO.popen("#{command} < ../compare_file/#{input_filename}.txt 1>../log/#{$time}_result 2> ../log/#{$time}_Aerror || echo 'error'") do |io|
	   		return_words = io.gets
	   	end
	    puts "actioning"
	    #TODO:status code 23の時でWAの時の処理
	    sleep 0.05
	    return_words == nil ? return_words ="" : return_words = return_words.chomp
	    if ((return_words == "error"))
	    	$status = 31
	    	puts "action Error occured, status is #{$status}"
	    	sleep 1
	    	exit()
	    end
	    puts "fin Aerror log judgement"
   	    
	    Compare.new.start(times)

	    times += 1
	end 
	puts "all problem_num is complete"
	Update_db.new
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
		ATLE_Java.new.judge_tle()
	end
end

class Action_Ruby < Action
	def make_command(times)
		return ("ruby main.rb") 
	end
	def judge_tle
		ATLE_Ruby.new.judge_tle()
	end
end

class Action_Python2 < Action
	def make_command(times)
		return ("python main.py") 
	end
	def judge_tle
		ATLE_Python.new.judge_tle()
	end
end

class Action_Python3 < Action
	def make_command(times)
		return ("/opt/local/bin/python3.3 main.py") 
	end
	def judge_tle
		ATLE_Python.new.judge_tle()
	end
end

#Action TLEの継承
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
#言語ごとの継承
class ATLE_C < ATLE
	def make_command()
		return("[a].out")
	end
end

class ATLE_Cpp < ATLE
	def make_command()
		return("[a].out")
	end
end

class ATLE_Ruby < ATLE
	def make_command()
		return("[r]uby main")
	end
end

class ATLE_Python < ATLE
	def make_command()
		return("[p]ython | grep [m]ain")
	end
end

class Compare
	def get_answers(file_times)
		count = 0
		@@answer = Array.new
		@@result = Array.new
		File.open("../compare_file/#{$questino_no}_out_#{file_times}.txt") { |file|
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
		puts "#{@@result} ?=? #{@@answer} "
		if (@@result == @@answer)
			$status = 4
			puts "get accept, status is #{$status}"
		else
			$status = 41
			puts "get wrong answer , status is #{$status}"
			exit()
		end
	end
	def start(file_times)
		get_answers(file_times)
		if ($allowable > 0)
			allowable()
		end
		compare()
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
	Action_Cpp.new.action()
when 2
	Compile_Java.new.compile()
	Action_Java.new.action()
when 3
	Action_Ruby.new.action()
when 4
	Action_Python2.new.action()
when 5
	Action_Python3.new.action()	
end
