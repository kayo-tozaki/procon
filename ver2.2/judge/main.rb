a = gets.to_i
result = 0
count = 1
count2 = 1
while count <= a
	while count2 <= a 
		result = result + count2 * count
		count2 = count2 + 1
		#puts result
	end
	count2 = 1
	count = count + 1
end

puts result