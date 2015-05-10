<?php
echo system('ls');
 set_time_limit(0);
        header("Content-Type: text/event-stream");
        header('Cache-Control: no-cache');
        
        echo "data:".system('ls')."\n";
        echo "retry: 3000";
?>