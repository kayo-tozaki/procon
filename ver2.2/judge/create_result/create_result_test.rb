#create_result_test.rb
#実行時引数に、結果表示に追加したい提出時刻を取る。

#GetData : 全結果表示。
#CountAC : AC数表示ページの生成 

require 'mysql'
class GetData
	def getFromDB
		day = Time.now.strftime("%y%m%d")
		client= Mysql.connect('localhost', 'procon', 'procon', 'submit')
		client.query("SELECT * FROM submit.submit_#{day} WHERE post_time = #{$time}").each do |post_time,team_name ,problem_num,language,status,part_point| 
		#client.query("SELECT * FROM submit.submit_#{day} WHERE post_time = #{$time} order by desc").each do |post_time,team_name ,problem_num,language,status,part_point|  # テスト用にDesc入ってるので注意
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
	def getFromText
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
	def visualize	#数字を文字列化しておく
		problem=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
		$VQuestion = problem[$questino_no-1]
		language = ["C","C++","Java","Ruby","Python2","Python3"]
		$VLanguage = language[$language]
		case $status
		when 1 
			$Vstatus = "Submited"
		when 2
			$Vstatus = "compiled"
		when 21
			$Vstatus = "compile error"
		when 22
			$Vstatus = "compile ,time over"
		when 23
			$Vstatus = "compile ,warnning occured"
		when 3
			$Vstatus = "Action finished"
		when 31
			$Vstatus = "Runtime Error"
		when 32
			$Vstatus = "TLE"
		when 4
			$Vstatus = "Accept"
		when 41
			$Vstatus = "Wrong Answer"	
		when 42
			$Vstatus = "Wrong Answer. maybe Runtime Error."
		end
		t = Time.at($time)
		$Vtime = t.strftime("%H:%M:%S")
	end

	def main
		getFromDB()
		getFromText()
		visualize()
		puts "team_name is #{$team_name} Question is #{$VQuestion} , Language is #{$VLanguage} , Status is #{$Vstatus} , count Ac is #{$part_point}/#{$input_times} "
	end
end

class Make_html		#一般結果ページの生成
	def table_header()
		header = %Q(<tr class="table_tr1"> \n <td class="table_td1"></td>  )
		return(header)
	end
	def table_footer()
		footer = %Q(</tr> \n)
		return(footer)
	end

	def make_file
		que = "#{open('create_result/HTMLa.txt').read}#{open('create_result/HTMLcore.txt').read}#{open('create_result/HTMLb.txt').read}"
		#Flle.write("result.html",que)
		f = open("#{$file_path}result.html",'w')
		f.write(que)
		f.close()
		puts "write html complete"
	end

	def create_html	#各要素のタグ囲みを行う
		start_tag = %Q(<td class="table_td1">)

		team_name = %Q(#{start_tag}#{$team_name}</td>)
		problem = %Q(#{start_tag}#{$VQuestion}</td>)
		language = %Q(#{start_tag}#{$VLanguage}</td>)
		time =  %Q(#{start_tag}#{$Vtime}</td>)

		if $status == 41 || $status == 42
			status = %Q"#{start_tag}#{$Vstatus}(#{$part_point}/#{$input_times})</td> "
		else
			status = %Q"#{start_tag}#{$Vstatus}"
		end
		tags = %Q( <tr class="table_tr1">
                <td class="table_td1"> </td> ) + team_name + problem + language + status + time + "<tr>"
		open('create_result/HTMLcore.txt','r+'){|f|
			f.puts "#{tags}#{open('create_result/HTMLcore.txt').read}"
		}
		make_file()
	end

end

class Count_AC	#AC数の計算
	def  find_data
		$last_time = 0
		$array_countAC_team_name = Array.new
		day = Time.now.strftime("%y%m%d")
		$hash = {}
		$time_hash = {}	#last_submit hash
		@@rank = 1	#for rank
		#reset core file 
		File.write("create_result/Screen_core.txt","")
		client= Mysql.connect('localhost', 'procon', 'procon', 'submit')
		client.query("SELECT team_name , problem_num , post_time FROM submit.submit_#{day} where status = 4 group by problem_num ,team_name order by post_time asc").each do |team_name,problem_num,post_time| 
		#client.query("SELECT * FROM submit.submit_#{day} WHERE post_time = #{$time} order by desc").each do |post_time,team_name ,problem_num,language,status,part_point|  # テスト用にDesc入ってるので注意
		  insert_hash(team_name,post_time)
		end
		puts "complete find_data"
		client.close
		$hash = $hash.sort {|(k1, v1, m1), (k2, v2,m2)|
		 v2 <=> v1 
		}
		times = 0
		nowcheckAC = 0
		ac_time_hash = {}
		$hash.each do |name,num,time|
			#p $hash
			nowAC = $hash[times][1][0]
			puts "#{nowAC} , #{times}"
			if times == 0 then 
				nowcheckAC = nowAC
				ac_time_hash["#{name}"] = $hash[times][1][1]
				puts ac_time_hash["#{name}"]
				times = times +  1
				puts times
			elsif nowAC != nowcheckAC
				#時間でソート。 
				if ac_time_hash.length != 1 then ac_time_hash = ac_time_hash.sort{|a,b| a <=> b} end
					ac_time_hash.each do |team_name,time|
					puts %Q(#{@@rank}.#{team_name} , #{nowcheckAC} ,#{time} )#{$time_hash["#{name}"]}")
					create_screen_html(team_name,nowcheckAC,@@rank)
					@@rank = @@rank + 1
				end
					#times = 0
					p name
					ac_time_hash = {}
					ac_time_hash["#{name}"] = $hash[times][1][1]
					puts ac_time_hash["#{name}"]
					times = times + 1
					nowcheckAC = nowAC
			else
				#ストックしておく。
				ac_time_hash["#{name}"] = $hash[times][1][1]
				puts ac_time_hash["#{name}"]
				times = times + 1
			end
		end
		if ac_time_hash.length != 1 then ac_time_hash = ac_time_hash.sort{|a,b| a <=> b} end
		ac_time_hash.each do |team_name,time|
			puts %Q(#{@@rank}.#{team_name} , #{nowcheckAC} ,#{time} )#{$time_hash["#{name}"]}")
			create_screen_html(team_name,nowcheckAC,@@rank)
			@@rank = @@rank+1
		end
		puts "result"
		p $hash
		finalize()
	end

	def insert_hash(team,post_time)
		if ($time_hash["#{team}"].to_i < post_time.to_i)
			  $time_hash["#{team}"] = post_time.to_i
		end
		  #first input
		  p $hash["#{team}"] == nil
		  if ($hash["#{team}"] == nil)
		  	ac_counter = 1
		  else
			ac_counter = $hash["#{team}"][0].to_i + 1
		  end

		  $hash["#{team}"] = ["#{ac_counter}","#{$time_hash["#{team}"]}"] 		#hash[team_name] => [CountAC,lastSubmit_time]
	end

	def create_screen_html(team_name,countAC,rank)
		#insert tag :<div class="rank">1. [ fakkin ] accept : 5</div>
		front_tag = %Q(<div class="rank">)
		end_tag = %Q(</div>)
		full_tag = "#{front_tag}#{rank}. [ #{team_name} ] accept : #{countAC} #{end_tag} \n"
		open('create_result/Screen_core.txt','a'){ |f|
			f.puts(full_tag)
		}
		puts "Write to core complete"
	end

	def finalize
		que = "#{open('create_result/Screena.txt').read}#{open('create_result/Screen_core.txt').read}#{open('create_result/Screenb.txt').read}"
		#Flle.write("result.html",que)
		f = open("#{$file_path}screen_result.html",'w')
		f.write(que)
		f.close()
		puts "write Screen html complete"
	end
end

	#main starting block
$time = ARGV[0].to_i
$file_path = "../problem_list/20150425/"	#環境変数になるので注意
if $time > 0 then
	puts $time
	GetData.new.main
	if !($status == 1 || $status == 2 || $status == 3) 
		Make_html.new.create_html
		Count_AC.new.find_data
	end
else
#only rewrite
	Make_html.new.make_file
	Count_AC.new.finalize
end
