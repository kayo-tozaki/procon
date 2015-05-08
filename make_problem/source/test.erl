%% A Hello World program in Erlang
-module(hello).
-export([start/0]).
start() -> io:fwrite("Hello World!\n").