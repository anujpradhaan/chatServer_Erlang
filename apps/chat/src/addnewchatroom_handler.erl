-module(addnewchatroom_handler).

-compile(export_all).

init({tcp,http},Req,Opts) ->
	{Method,Req2} =cowboy_req:method(Req),
	io:format("Method : ~p",[Method]),
	HasBody = cowboy_req:has_body(Req),
	Req3 = addNewChatRoom(Method,HasBody,Req),
	{ok,Req2,Opts}.

addNewChatRoom(<<"POST">>,true,Req) ->
	{ok,PostVals,Req2} =cowboy_req:body_qs(Req),
	NewRoom = proplists:get_value(<<"newroomname">>,PostVals),
	Username = proplists:get_value(<<"username">>,PostVals),
	io:format("NewRoom : ~p ~n~n",[NewRoom]),
	Validate = addRoom(NewRoom,Username,Req),
	io:format("validate : ~p ~n~n",[Validate]),
	try replyToUser(Validate,Req)
    catch
    	error:Reason ->
        io:fwrite("Error reason: ~p~n", [Reason]);
   		 throw:Reason ->
        io:fwrite("Throw reason: ~p~n", [Reason]);
    	exit:Reason ->
        io:fwrite("Exit reason: ~p~n", [Reason]), 		
		cowboy_req:reply(500,[],<<"Exception Occured">>,Req)
	end;
addNewChatRoom(<<"GET">>,true,Req) ->
	{ok,PostVals,Req2} =cowboy_req:body_qs(Req),
	NewRoom = proplists:get_value(<<"newroomname">>,PostVals),
	Username = proplists:get_value(<<"username">>,PostVals),
	io:format("NewRoom : ~p ~n~n",[NewRoom]),
	Validate = addRoom(NewRoom,Username,Req),
	io:format("validate : ~p ~n~n",[Validate]),
	try replyToUser(Validate,Req)
    catch
    	error:Reason ->
        io:fwrite("Error reason: ~p~n", [Reason]);
   		 throw:Reason ->
        io:fwrite("Throw reason: ~p~n", [Reason]);
    	exit:Reason ->
        io:fwrite("Exit reason: ~p~n", [Reason]), 		
		cowboy_req:reply(500,[],<<"Exception Occured">>,Req)
	end;	
addNewChatRoom(<<"POST">>,false,Req) ->
	cowboy_req:reply(400,[],<<"Missing body">>,Req);
addNewChatRoom(_,_,Req) -> 
	io:format("No post and body method given ~n"),
	cowboy_req:reply(405,Req).

%%Add the room to DB
addRoom(NewRoom,Username,Req) -> 
	model_users:addNewRoom(NewRoom,Username,Req).

replyToUser({atomic,[]},Req) ->
	cowboy_req:reply(405,[],<<"Invalid">>,Req);
replyToUser({atomic,ok},Req) -> 
	cowboy_req:reply(200,[],<<"Done">>,Req);
replyToUser(_,Req) -> 
	cowboy_req:reply(200,[],<<"Error">>,Req).