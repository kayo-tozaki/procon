# coding: utf-8
#Start this program , then reset website
#require './remove'
def save_add_data(x,team_name,time)
        puts "#{x}"
        puts "get data"
	write_data=""
	status=["accept","TLE","wrong","compile error"]
	problem=["A","B","C","D","E","F","G","H","I","J","K"]
    write_data=write_data+team_name.chomp+","+problem[x.to_i/100-1]+","+status[x.to_i%100/10-1]+","+time.chomp+"\n"
	data_num=1#data数
        puts "submit_data.log"
	File.open("./ruby_status/submit_data.log","r+") {|file|
	while l = file.gets#dataを一行ずつ読み込む
		write_data=write_data+l
		data_num+=1
	end
 	file.rewind
	file.write(write_data)#新しいデータを一番上に追加
    }
    puts "end get data"
    print_log_html(data_num)#データ一覧をHTMLに書き出す
    if x.to_i%100/10-1==0 then#データがacceptの時だけ全体順位を再考する
    	read_data(problem)
    end
end
#　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
def print_log_html(data_num)
        puts "add tag"
	write_data=""
	way=0
        puts "read submit_data.log"
	File.open("./ruby_status/submit_data.log","r") {|file|
	while l = file.gets#データを一行ずつ読み込む
		fields = l.split(',')
		if way==0 then#データのテーブル背景を変えるために交互にタグを変える
			temp="<tr class=\"table_tr1\"><td class=\"table_td1\">#{data_num}</td>"
			fields.each{|element|
				temp=temp+"<td class=\"table_td1\">#{element.chomp}</td>"
			}
			temp=temp+"</tr>"
			way=1
		else
			temp="<tr class=\"table_tr2\"><td class=\"table_td1\">#{data_num}</td>"
			fields.each{|element|
				temp=temp+"<td class=\"table_td1\">#{element.chomp}</td>"
			}
			temp=temp+"</tr>"
			way=0
		end
		data_num-=1#データ番号を上から振ってるため合計値から引いていく
		write_data=write_data+temp#タグ付けしたデータを追加していく
	end
    }
    puts "end add tag"
    create(write_data)#タグ付けしたデータを送る
end

def create(write_data)#提出結果一覧
	puts "start creating web page..."
	html_data_a=""
	html_data_b="</table>
    </div>
    <div id=\"head_margin\"></div>
	<div id=\"footer_wrapper\">
    	<div id=\"header_navi\" class=\"cf\">
			<div id=\"footer_time\"></div>
			<div id=\"footer\">Do your best.</div>
        </div>
	</div>
	<SCRIPT Language=\"JavaScript\">
	<!--
	function Rld()
	{
	location.reload();
	}
	setTimeout(\"Rld()\",10000);
	// -->
	</SCRIPT>
</body>
</html>"
	File.open("./ruby_status/HTMLa.txt","r") {|file|#HTMLデータの前半を読みだす
	while l = file.gets
		html_data_a=html_data_a+l
	end
	}
	f=open('../problem_list/20150210/result.html','w')#　　　　　　環境依存に注意
	f.write(html_data_a+write_data+html_data_b)#HTMLデータの前半+データ+HTMLの後半
	f.close()
	puts "finished renewal page"
end

#　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
def read_data(problem)
	team_list=[]
	File.open("./ruby_status/submit_data.log","r") {|file|#一覧データからチームリスト作成する
	while l = file.gets#dataを一行ずつ読み込む
		fields = l.split(',')
		team_list.push(fields[0].chomp)
	end
	}
	data=[0]*team_list.uniq!.length*10#重複してないチーム数*10個分の問題データ枠を確保
#	puts "#{team_list}"
	File.open("./ruby_status/submit_data.log","r") {|file|
	while l = file.gets#dataを一行ずつ読み込む
		fields = l.split(',')
		count=0#問題の特定
		problem.each{|pro|#問題A～Kまでを繰り返す
			#読み込んだデータと査定している問題番号が同じで状態がacceotの時に
			if pro.chomp== fields[1].chomp && fields[2].chomp=="accept".chomp then#問題番号が同じでacceptの時
				count2=0#チームの特定
				team_list.each{|team|#チームを照合していく
					if fields[0]==team then#チームが同じ時
						data[count2*10+count]+=1#チーム毎の問題番目に足していく
					end
					count2+=1
				}
			end
		count+=1
		}
	end
	}
	result=[0]*50#最大データ数分の枠を準備
	#最大チーム50までに制限される
	count=0
	data.each{|i|
		if i!=0 then#チームの重複しないacceptの数を数える
			result[count/10]+=1
		end
		count+=1
	}
	rank={}
	count=0
	team_list.each{|team|#チームに対するaccept数のハッシュデータを作成する
		rank.store(team,result[count])
		count+=1
	}
	result=rank.sort_by{|key,val|-val}#acceptの多い順に並べ直す
#	puts "#{result}"
	screen(result)#整理したデータを書き出し用関数に送る
end

def screen(result)
	puts "renew screen page"
	write_data=""
	rank=""
	count=1#順位
	temp=0
	result.each{|key,val|
		if val>0 then#accept数が０より大きい時
			if temp==val then#同じ順位の時の処理
				count-=1
			end
			rank=rank+"<div class=\"rank\">#{count}. [ #{key} ] accept : #{val}</div>"
			count+=1
			temp=val#同順位の時のために前の順位を保持しておく
		end
	}
	#puts "#{rank}"
	begin	
	File.open("./ruby_status/result_list.data","r") {|file|
	while l = file.gets#dataを一行ずつ読み込む
		if l.chomp.gsub(" ", "")=="[MYPROGRAM]" then#HTMLデータから書き出したい場所のタグを発見する
			write_data=write_data+rank#発見した時だけ代わりに作っておいたデータを追加する
		else
			write_data=write_data+l
		end
	#puts write_data
	end
	}
	rescue Exception => e
		puts "error occured#{e.class}"
		
	end
	#puts "#{write_data}"
	f=open('./ruby_status/result_list.html','w')
	f.write(write_data)#HTMLデータ全てを書き出して終了
	f.close()
	puts "finish renew screen page"
end

#save_add_data(510,"ryuno","17:40:00")
