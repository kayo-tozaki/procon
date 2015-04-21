#test of ulimit

require './ruby_status/create_result'

def compile(file_name)
	puts "#{file_name}"
	command = "echo \"No compile_files\""	#default用のコマンド

	case $language
	when 0
	command = "g++ ../submit_file/#{file_name}.cpp -o ../submit_file/#{file_name} 2> ../submit_file/#{file_name}_compile"
	puts "g++ compile complete"
	when 1
	command = "g++ ../submit_file/#{file_name}.cpp -o ../submit_file/#{file_name} -std=c++11 2> ../submit_file/#{file_name}_compile"
	puts "g++ -std=gnu++11 complete"
	when 2
	file_name = "#{$team_name}"
	command = "cp -f ../submit_file/#{$team_name}.java ../submit_file/Main.java && /usr/local/src/jdk1.8.0_40/bin/javac ../submit_file/Main.java  2> ../submit_file/#{file_name}_compile"
	puts "javac compile end"
	end
	puts "\nStartig compile..."
	IO.popen(command)

	#compile tleの判断
	compile_tle(file_name)

	#コンパイルの結果、ファイルの検査。
	if $language == 0 || $language == 1 || $language == 2
		
	open("../submit_file/#{file_name}_compile", "r") {|file|
		if file.size > 0
	 		puts "compile error"
	 		#TODO:コンパイルエラーのモードに変更
	 		save_add_data($questino_no*100+4*10+$rank*1,$team_name,$submit_time)
	 		rm = "rm #{file_name}_compile"
	 		system(rm)
	 		exit
	 	else
	 		puts "compile success"
	 		#コンパイル判断用ファイルの削除
			rm = "rm #{file_name}_compile"
			puts "removing file ..."
	 		system(rm)
	 		puts "success"
			break
	 	end
	}
	end

end

def compile_tle(file_name)
	submit_file_name = "../submit_file/#{file_name}"
	file_name_tle = file_name.clone
	file_name_tle[0] = "../submit_file"+"["+file_name_tle[0]+"]"
	puts "judge compile tle..."

	sleep 2
	if %x(ps alx |grep "g++ #{file_name_tle}.cpp -").empty? == false && ($language == 0 || $language == 1)
		kill_command = %Q(kill `ps alx |grep "#{file_name_tle}"` ) 
		puts "over time. kill compile process"

		#web page 先行更新（TLE）
		save_add_data($questino_no*100+4*10+$rank*1,$team_name,$submit_time)
		IO.popen(kill_command)
		exit
	elsif %x(ps alx |grep "g++ [M]ain.java -").empty? == false && ($language == 2)
		kill_command = %Q(kill `ps alx |grep "#{file_name_tle}"` ) 
		puts "over time. kill compile process"

		#web page 先行更新（TLE）
		save_add_data($questino_no*100+4*10+$rank*1,$team_name,$submit_time)
		IO.popen(kill_command)
		exit
	end
		
end


def action(file_name,questino_no)
	case $language
	when 0
		command = "../submit_file/#{file_name} < ../compare_file/#{questino_no}_in_#{$input_times}.txt 1> ../submit_file/#{file_name}_after_action"
	when 1
		command = "../submit_file/#{file_name} < ../compare_file/#{questino_no}_in_#{$input_times}.txt 1> ../submit_file/#{file_name}_after_action"		
	when 2
		command = "cd ../submit_file && /usr/java/jre1.8.0_40/bin/java Main < ../compare_file/#{questino_no}_in_#{$input_times}.txt 1> ../submit_file/#{file_name}_after_action"
	puts "java run command set"
	when 3
		command = "ruby ../submit_file/#{file_name}.rb < ../compare_file/#{questino_no}_in_#{$input_times}.txt 1> ../submit_file/#{file_name}_after_action"
		puts "ruby run command set"
	when 4
		command = "python ../submit_file/#{file_name}.py < ../compare_file/#{questino_no}_in_#{$input_times}.txt 1> ../submit_file/#{file_name}_after_action"
	puts "python2 run command set"
	when 5
		command = "python3 ../submit_file/#{file_name}.py < ../compare_file/#{questino_no}_in_#{$input_times}.txt 1> ../submit_file/#{file_name}_after_action"
	puts "python3 run command set"
	end


#	if $language == 2
#		command = "../submit_file/#{team_name}.class <<"
#	end
	puts "Startig action..."
	IO.popen(command)
	
	#tleの判断
	tle(file_name)
	puts "Finish action"
end

#TODO:scanfでの時間稼ぎは全く聞かない。WorngAnserとなる。TLEにならない。
def tle(file_name)
	file_name_tle = file_name.clone
	file_name_tle[0] = "../submit_file/"+"["+file_name_tle[0]+"]"
	puts "judge action tle..."

	sleep $action_sec
	if %x(ps alx |grep "sh"|grep "#{file_name_tle}").empty? == false
		kill_command = %Q(kill `ps alx |grep "#{file_name_tle}"`) 
		puts "over time. kill action process"
		
		#web 更新 & 後処理
		save_add_data($questino_no*100+2*10+$rank*1,$team_name,$submit_time)
		sleep 1
		rm_command = %Q(sudo rm #{file_name}_after_action)
		system(rm_command)
		IO.popen(kill_command)
		exit
	end
end

def compare(file_name)
	anser = Array.new
	af = Array.new
	count = 0
	puts "Start compare..."
	File.open("../compare_file/#{$questino_no}_out_#{$input_times}.txt") { |file|
		file.each_line do |val|
				anser[count] = val.chomp
				count += 1
			end
	  }
	count  = 0
	File.open("../submit_file/#{file_name}_after_action") { |file|
		file.each_line do |val|
			af[count] = val.chomp
			count += 1
		end
	}


	#ファイルの未設置によるエラー処理
	# begin
	# af = IO.readlines("../submit_file/#{file_name}_after_action")
	# anser = IO.readlines("../compare_file/#{$questino_no}_out_#{$input_times}.txt")	
	# rescue Exception => e
	# 	puts "Admin Error #{e.class}"
	# 	exit
	# end

	count = 0
	#puts $allowable
	if ($allowable > 0 && af.include?("."))
		af.each do |value|
			af_min = value.split(".")
			#puts "af_min[0]:#{af_min[0]} , af_min[1][0];#{af_min[1][0]} , af_min[1][1]:#{af_min[1][2]}"			
			af_min[1] = af_min[1].each_char.each_slice($allowable).map(&:join)
			#puts "af_min[0]:#{af_min[0]} , af_min[1][0];#{af_min[1][0]} , af_min[1][1]:#{af_min[1][2]}"	
			af[count] = af_min[0].to_s + "." + af_min[1][0].to_s
			#puts af[count]
			count+=1
		end

		p af 
		p anser
	end
		if tf = (af == anser) == true
			puts "Accept!"
			
			return 1
		else
			puts "Wrong Answer!"


			return 3
		end
end



#teamname
$team_name = gets.chop
#questionNo.
$questino_no = gets.to_i
#action sec
$action_sec = gets.to_i
#limit memory
$limit_memory = gets.to_i
#input times
$input_times = gets.to_i
#allowable
$allowable = gets.to_i

#language
$language = gets.to_i

#create file name
$file_name = $team_name + "_" + $questino_no.to_s

$rank = 0

#send to cre_result.rb
day = Time.now
$submit_time = day.hour.to_s + ":".to_s + day.min.to_s + ":".to_s + day.sec.to_s


#puts "#{$file_name},#{$questino_no},#{$team_name}"
compile($file_name)
while $input_times > 0
	action($file_name, $questino_no)
	ret = compare($file_name)
        if ret == 3
	 result = $questino_no*100+ret*10+$rank*1
	 break;
	end
	result = $questino_no*100+ret*10+$rank*1
	$input_times = $input_times - 1
end
save_add_data(result,$team_name,$submit_time)
sleep 1
#後処理
#rm_command = %Q(rm ../submit_file/#{$file_name}_after_action)
#system(rm_command)
puts "All programs finished!"
