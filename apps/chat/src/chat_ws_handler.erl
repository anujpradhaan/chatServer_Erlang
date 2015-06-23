-module(chat_ws_handler).
-behaviour(cowboy_websocket_handler).

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
    {upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) ->
    chat_room:enter(self()),
    {ok, Req, undefined_state}.

websocket_handle({text, Msg}, Req, State) ->
    %Make the DB entry here and If the chat room is unique then create it otherwise report and error.
    %MsgList=string:tokens(Msg,",").
    %if string:len(MsgList) > 1 ->
    %    [Head|Tail] = MsgList,
    %    if string:equals(Head,"newroom") ->
    %        chat_room:set_new_chatroom(self(),Tail)
    %    end,
    %    if string:equals(Head,"chatroom") ->
    %        chat_room:send_message_in_chatroom(self(),Tail)
    %    end    
    %end,    
    chat_room:send_message(self(), Msg),
    {ok, Req, State};
websocket_handle(_Data, Req, State) ->
    {ok, Req, State}.

websocket_info({send_message, _ServerPid, Msg}, Req, State) ->
    {reply, {text, Msg}, Req, State};
websocket_info(_Info, Req, State) ->
    {ok, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
    chat_room:leave(self()),
    ok.
