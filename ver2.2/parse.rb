 require 'json'
require 'mysql'

#day = Time.now

file_name = "20150425.json"#{day.year}#{day.month}#{day}"

json_file_path = "./problem_list/#{file_name}"
json_data = open(json_file_path) do |io|
  JSON.load(io)
end
question_num = 0
#puts json_data["contest"]["question"][question_num]["time"]

while true
	begin
		#print json_data["contest"]["question"][question_num]["problem"]
		output_data = "#{json_data["contest"]["question"][question_num]["time"]}\n#{json_data["contest"]["question"][question_num]["mem"]}\n#{json_data["contest"]["question"][question_num]["numOfTestcase"]}\n#{json_data["contest"]["question"][question_num]["precision"]}"
		#puts output_data
		File.write("./judge/#{question_num+1}", output_data)
		
		question_num = question_num+1	
	rescue Exception => e
		#puts e.class
		break;
	end
end
