num = gets.to_i
#num = 3
count_x = 1
count_y = 1
$ans = 0
while count_x < num+1 do
#	puts "start count_x"
	while count_y < num+1 do
#		puts "start count_y"
		$ans = count_x*count_y + $ans 
		count_y = count_y+1
#		puts $ans
	end
#
	count_y = 1
	count_x = count_x+1
end

puts $ans
