-module(chat_http_signup_handler).
-export([init/3]).

init({tcp,http},Req,Opts) ->
	{Method,Req2} = cowboy_req:method(Req),
	io:format("Method : ~p",[Method]),
	HasBody = cowboy_req:has_body(Req),
	Req3 = signUp(Method,HasBody,Req),
	{ok,Req3,Opts}.

%%SignUp using the parameters available in the HTTP Request
signUp(<<"POST">>,true,Req) ->
	{ok,PostVals,Req2} =cowboy_req:body_qs(Req),
	Username = proplists:get_value(<<"username">>,PostVals),
	Password = proplists:get_value(<<"password">>,PostVals),
	Email = proplists:get_value(<<"email">>,PostVals),
	Country = proplists:get_value(<<"country">>,PostVals),
	Dob = proplists:get_value(<<"dob">>,PostVals),
	Status = createNewUser(Username,Password,Email,Country,Dob,Req),
	try replyToUser(Status,Req)
    catch
    	error:Reason ->
        io:fwrite("Error reason: ~p~n", [Reason]);
   		 throw:Reason ->
        io:fwrite("Throw reason: ~p~n", [Reason]);
    	exit:Reason ->
        io:fwrite("Exit reason: ~p~n", [Reason]), 		
		cowboy_req:reply(500,[],<<"Exception Occured">>,Req)
	end;
%%SignUp using the parameters available in the HTTP Request
signUp(<<"GET">>,true,Req) ->
	{ok,PostVals,Req2} =cowboy_req:body_qs(Req),
	Username = proplists:get_value(<<"username">>,PostVals),
	Password = proplists:get_value(<<"password">>,PostVals),
	Email = proplists:get_value(<<"email">>,PostVals),
	Country = proplists:get_value(<<"country">>,PostVals),
	Dob = proplists:get_value(<<"dob">>,PostVals),
	Status = createNewUser(Username,Password,Email,Country,Dob,Req),
	try replyToUser(Status,Req)
    catch
    	error:Reason ->
        io:fwrite("Error reason: ~p~n", [Reason]);
   		 throw:Reason ->
        io:fwrite("Throw reason: ~p~n", [Reason]);
    	exit:Reason ->
        io:fwrite("Exit reason: ~p~n", [Reason]), 		
		cowboy_req:reply(500,[],<<"Exception Occured">>,Req)
	end;		
signUp(<<"POST">>,false,Req) -> %%If the Body is not available then show error
	cowboy_req:reply(400,[],<<"Missing body">>,Req);
signUp(_,_,Req) -> 
	io:format("No post and body method given ~n"),
	cowboy_req:reply(405,Req).	%%If the Method is something else from POST then obviously you need not handle the request and show an error

%% Reply to user according to the DB insertion results
replyToUser(ok,Req) -> 
	cowboy_req:replyToUser(200,[],<<"User Created">>,Req);
replyToUser(_,Req) -> 
	cowboy_req:reply(200,[],<<"Error">>,Req).	



createNewUser(Username,Password,Email,Country,Dob,Req) ->
	model_users:insert_users(Username,Password,Email,Country,Dob,Req).
 	


