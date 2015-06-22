-module(model_users).

-compile(export_all).

-include("chatroom_db.hrl").

insert_users(Username,Password,Email,Country,Dob,Req) ->
    User = #users{
    	username=Username, %%username provided  by the user
		dob=Dob, %%Date of birth of the user
		password=Password, %%password for the user account
		email=Email,
		country=Country,
		type="user", %%Type of user, 1 = general user, 2= admin,
		active=1
    	},
    U = fun() ->
          mnesia:write(User)
        end,
    mnesia:transaction(U). 

checkValidUser(Username,Password) -> 
    Pattern = #users{username=Username,password=Password,_='_'},
    F1=fun() -> 
        Row=mnesia:match_object(Pattern),
        [{Username,Password,Dob,Country,FullName,Email,Type,Active} || 
            #users{dob=Dob,
                        country=Country,
                        full_name=FullName,
                        email=Email,
                        type=Type,
                        active=Active} <- Row]
        end,
        mnesia:transaction(F1).                
    %F = fun() -> 
    %    [Result] = mnesia:read(users,Username),
    %     io:format("Result is ~p~n",[Result])
    %    end,
    %mnesia:transaction(F).
    %reply(F).

reply(F) -> 
    case F of 
        {atomic,Result} ->
            Result;
        {aborted,Result} -> 
            [];
         {_,Result} ->
            Result      
    end.    
   %% case Result#users.password =:= Password of 
    %%    true ->  
     %%   io:format("Valid Username,Password~n"),
       %% ok;
        %%false ->
        %%io:format("Invalid username password combination~n"),
        %%reject
    %%end.

         