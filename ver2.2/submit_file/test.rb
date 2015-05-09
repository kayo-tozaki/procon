warning & wrong answer => runtime error?
	    if !`cat ../log/#{$time}_log |grep "warning"`.empty?
	    	puts "warning occured"
	    end