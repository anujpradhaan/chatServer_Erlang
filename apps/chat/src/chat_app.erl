-module(chat_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	ErrorTuple = {error,{nonode@nohost,{already_exists,nonode@nohost}}},
	%mnesiaSchema = mnesia:create_schema([node()]), % Find a way to check whether the schema exists or not. If yes then ignore this statement
	%if ErrorTuple =:= mnesiaSchema ->
	%	io:format("mnesia schema already exists ~n"),
	%	error
	%end,	
	
	mnesia:start(), %Find a way to check whether mnesia is running already or not. If yes, ignore this, otherwise start mensia.
    admin_handler:init(),
    %admin_handler:reset(),
    chat_sup:start_link().

stop(_State) ->
    ok.
