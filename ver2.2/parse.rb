#parse.rb : JSONファイルから、問題設定ファイルを、judge/* に保存する。
require 'json'
require 'mysql'

#day = Time.now

file_name = "20150425.json"#{day.year}#{day.month}#{day}" , 問題セットの日付にすること。

#jsonからデータを取り込む。
json_file_path = "./problem_list/#{file_name}"
json_data = open(json_file_path) do |io|
  JSON.load(io)
end
question_num = 0

#ファイルへの書き出し
while true
	begin
		output_data = "#{json_data["contest"]["question"][question_num]["time"]}\n#{json_data["contest"]["question"][question_num]["mem"]}\n#{json_data["contest"]["question"][question_num]["numOfTestcase"]}\n#{json_data["contest"]["question"][question_num]["precision"]}"
		File.write("./judge/#{question_num+1}", output_data)
		question_num = question_num+1	
	 rescue Exception => e
		break;
	end
end
