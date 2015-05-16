
require 'mysql'

class Preparation
	def getDB()		#DBからデータの取得
		day = Time.now.strftime("%y%m%d")
		client= Mysql.connect('localhost', 'procon', 'procon', 'submit')
		#client.query("SELECT * FROM submit.submit_#{day} WHERE status < 40 && status != 4 order by post_time desc").each do |post_time,team_name ,problem_num,language,status,part_point|  # テスト用にDesc入ってるので注意
		client.query("SELECT * FROM submit.submit_#{day} WHERE status = 1").each do |post_time,team_name ,problem_num,language,status,part_point|
		  $time = post_time.to_i
		  $team_name = team_name
		  $questino_no = problem_num.to_i
		  $language = language.to_i
		  $status = status.to_i
		  $part_point = part_point.to_i
		  break
		end
		puts "complete getDB"
		client.close
	end
	def getQdata()		#問題configからのデータ取得
		begin
			f = open("#{$questino_no}", "r")
		rescue Exception => e
			puts "Error occured. exit program : #{e.class}"
			exit
		end
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
	    command = %Q(cp -r ../submit_file/#{$time} #{file_name})
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
		return("各言語ごとのcompile文")
	end
	def judge_compile_tle_command	#各言語のclass TLEへの継承先コマンドの記述
		commnand.new.judge_tle		#各言語で継承
	end
	def judge_compile()				#コンパイルができたかの判断とDBの更新
		judge_compile_tle_command()
		size = File.open("../log/#{$time}_compile").size
		puts "judge compile error #{$time}"
		if !`cat ../log/#{$time}_compile |grep "警告"`.empty?
	    	puts "warning occured"
	    	$status_code = 23		#division Error の場合は Runtime Errorになるので。
	    	Update_db.new
	    end
		puts "log file size is #{size}"
		if( size <= 0 ) then
			$status = 2
			Update_db.new
			puts "compile complete"
		else
			$status = 21
			puts "compile fail"
			Update_db.new
			exit()
		end
		puts "fin compile error"
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
		#puts %x(ps alx |grep "#{command}").empty?

		if (%x(ps alx |grep "#{command}").empty?) then
		 $status = status_code()
		 puts "Not action."
		else
		 num = status_code()
		 $status = num*10+2
		 Update_db.new
		 puts "TLE,kill process status is #{$status}"
		 Process.kill('KILL',$io.pid)	#terminated
		 puts "now runnnng judge.rb process..."
		 IO.popen("ruby killer.rb &")	#if ruby, after action hear terminated
		 exit()
		end
		puts "judge_tle complete. $status is #{$status}"
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
	   	$io = IO.popen("#{command} < ../compare_file/#{input_filename}.txt ") #TLE判断用に１回実行
	   	judge_tle()
	   	#本実行。
	   	IO.popen("#{command} < ../compare_file/#{input_filename}.txt 1>../log/#{$time}_result 2> ../log/#{$time}_Aerror || echo 'error'") do |io|
	   		return_words = io.gets
	   	end
	    puts "actioning"
	    sleep 0.05
	    return_words == nil ? return_words ="" : return_words = return_words.chomp
	    if ((return_words == "error"))
	    	$status = 31
	    	puts "action Error occured, status is #{$status}"
	    	Update_db.new
	    	exit()
	    end
	    puts "fin Aerror log judgement"

	    Compare.new.start(times)

	    times += 1
	end
	puts "all problem_num is complete"
	#Update_db.new
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
		command = %Q([p]ython" | grep "[m]ain)
		return(command)
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
		#sleep 1
		puts !`cat ../log/#{$time}_runError.log`.empty?
		if (@@result == @@answer)
			$status = 4
			$part_point = $part_point + 1
			puts "get accept, status is #{$status}"
		elsif $status == 23 || !`cat ../log/#{$time}_runError.log`.empty?
			$status = 42
			puts "get Wrong Answer. Get compile error, if you get runtime error...?"
		else
		    #TODO:status code 23の時でWAの時の処理
			$status = 41
			puts "get wrong answer , status is #{$status}"
			Update_db.new
		end
		if $status == 41 || $status ==42
			exit()
		end
		Update_db.new
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
		print "update database..."
		stack = $time
		# stack = File.read("Result")
		# puts stack.to_i
		# stack = stack.to_i + 1
		client= Mysql.connect('localhost', 'procon', 'procon', 'submit')
		query = "update submit.submit_#{Time.now.strftime("%y%m%d")} set status = \'#{$status}\',part_point = \'#{$part_point}\' where post_time = #{$time}"
		#puts query
		client.query(query)
		client.close
		unless $status == 4 then
		 if $part_point == $input_times then
			File.write("Result",stack)
			puts "wirte Result"
		 else
			File.write("Result",stack)
			puts "wirte Result"
	 	 end
		end
		print "update DB complete! \n"
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

=begin

##judge.rb各クラスの動き（メモ）
##Preparation
各種データの取得を行います。取得するデータは次の通り。
###From DB
 * 提出時間
 * チーム名
 * 問題番号
 * 提出言語
 * ステータスコード

##From Question_config Data
 * 実行時間
 * メモリー制限
 * テストケース数
 * 誤差容認の桁数

また、実行するファイルを拡張子付きで再保存します。 (`def file_changer`)

##Compile
提出されたプログラムのコンパイルを行います。コンパイル時のコンパイル爆撃を防止するために、TLEを設け、時間を過ぎたものはTLEとして判断します。（結果表示は別途）

コンパイルコマンドは、別途 子クラスで作成したものを使用します。言語によってTLEのコマンドも変更させます。

##TLE
TLE（TimeLongError）の判断を行います。本プログラムでは、

 * コンパイル
 * 実行

のTLE判断を実施します。

TLEの判断に使用されるコマンドは各言語によって異なるため、言語ごとに子クラスで指定しています。

##Action
コンパイルされたコード、及びインタプリタ型のコードを実行します。

実行用のコードは、子クラスで指定します。

##Compare
実行結果を比較します。

#inotify.sh
STOCK（テキストファイル）の変化イベントをキャッチし、run.sh → judge.rbを実行させるスクリプト。
ストックがたまっているときは、残弾が０になるまでやり続ける。
また、`judge.rb`が実行時は、何もしない（そのうち実行されるため。)

Killによる消失からの復旧のため、`../crontab.sh`を用意。それからも実行される

#Time (txtファイル。拡張子なし)
PHPが生成している。各種ログの時間表示のために生成。
中身は、提出時刻。ログファイルを整える関係上登場
=end
