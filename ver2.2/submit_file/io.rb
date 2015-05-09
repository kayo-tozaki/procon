begin
ret = IO.popen("./a.out > log && echo 'ok' || echo 'ng'" ,"r+"){|io|
	io.gets
}
puts ret
ret = IO.popen("./a2.out > log && echo 'good' || echo 'error'" ,"r+"){|io|
	io.gets
}
puts ret
rescue Exception => e
puts "error #{e.class}"	
end
