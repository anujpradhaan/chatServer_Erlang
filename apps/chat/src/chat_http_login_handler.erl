-module(chat_http_login_handler).
-export([init/3]).

init({tcp,http},Req,Opts) ->
	{Method,Req2} =cowboy_req:method(Req),
	HasBody =cowboy_req:has_body(Req),
	%%io:format("Method is ~p ~n",[Method]),
	Req3 = checkLogin(Method,HasBody,Req),
	{ok,Req2,Opts}.

checkLogin(<<"POST">>,true,Req) ->
	{ok,PostVals,Req2} =cowboy_req:body_qs(Req),
	Username = proplists:get_value(<<"username">>,PostVals),
	Password = proplists:get_value(<<"password">>,PostVals),
	io:format("Username : ~p ~n~n",[Username]),
	Validate = validateUser(Username,Password,Req),
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
checkLogin(<<"GET">>,true,Req) ->
	{ok,PostVals,Req2} =cowboy_req:body_qs(Req),
	Username = proplists:get_value(<<"username">>,PostVals),
	Password = proplists:get_value(<<"password">>,PostVals),
	Validate = validateUser(Username,Password,Req),
	io:format("User details : ~p~n",[Validate]),
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
checkLogin(<<"POST">>,false,Req) ->
	cowboy_req:reply(400,[],<<"Missing body">>,Req);
checkLogin(_,_,Req) -> 
	io:format("No post and body method given ~n"),
	cowboy_req:reply(405,Req).	

validateUser(undefined,undefined,Req) -> 
	cowboy_req:reply(400,[],<<"Missing Both Parameters">>,Req);
validateUser(undefined,Password,Req) -> 	
	cowboy_req:reply(400,[],<<"Missing username Parameter">>,Req);
validateUser(Username,undefined,Req) -> 	
	cowboy_req:reply(400,[],<<"Missing password Parameter">>,Req);
validateUser(Username,Password,Req) ->
	model_users:checkValidUser(Username,Password).
%% Reply to user according to the DB insertion results
replyToUser({atomic,[]},Req) ->
	cowboy_req:reply(405,[],<<"Invalid">>,Req);
replyToUser({atomic,Row},Req) -> 
	cowboy_req:reply(200,[],<<"Done">>,Req);
replyToUser(_,Req) -> 
	cowboy_req:reply(200,[],<<"Error">>,Req).
