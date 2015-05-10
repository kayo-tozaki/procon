pid = %q(echo `ps ax |grep "[r]uby main"|awk '{print $1}'`)
Process.kill('KILL',pid.to_i)