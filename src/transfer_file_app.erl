%%%-------------------------------------------------------------------
%% @doc transfer_file public API
%% @end
%%%-------------------------------------------------------------------

-module(transfer_file_app).

-behaviour(application).

-export([start/1, stop/1, rpc/4, get_file/2, list_files/1]).

start(Node) ->
    spawn(Node, fun() ->
		  loop() end).

rpc(Pid, Module, Fun, Args) ->
    Pid ! {rpc, self(), Module, Fun, Args},
    receive
	{Pid, Response} ->
	    Response
    end.

get_file(Pid, File) ->
    {ok, Binary} = transfer_file_app:rpc(Pid, file, read_file, [File]),
    file:write_file(File, [Binary]).

list_files(Pid) ->
    transfer_file_app:rpc(Pid, file, list_dir, ["."]).

stop(Pid) ->
    exit(Pid, ok).

%% internal functions

loop() ->
    receive
	{rpc, Pid, Module, Fun, Args} ->
	    Pid ! {self(), (catch apply(Module, Fun, Args))},
	    loop()
    end.
