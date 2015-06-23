-module(availablechatrooms_handler).

-compile(export_all).

-include("chatroom_db.hrl").

-include_lib("stdlib/include/qlc.hrl").

init({tcp,http},Req,Opts) ->
	{Method,Req2} =cowboy_req:method(Req),
	io:format("Method : ~p",[Method]),
	HasBody = cowboy_req:has_body(Req),
	Chatrooms=readAllChatRooms(),
	%%Req3 = addNewChatRoom(Method,HasBody,Req),
	replyToUser(Chatrooms,Req),
	{ok,Req2,Opts}.

readAllChatRooms() ->
	F = fun() ->
		Q = qlc:q([E#chatrooms.name || E <- mnesia:table(chatrooms)]),
		qlc:e(Q)
	end,
    mnesia:transaction(F).
    	
replyToUser({atomic,Result},Req) ->
	io:format("All Chatrooms are ~p~n",[Result]),
	B=[binary_to_list(Item) || Item <- Result],
	cowboy_req:reply(200,[],string:join(B, ","),Req);
replyToUser(_,Req) -> 
	cowboy_req:reply(200,[],<<"Error">>,Req).