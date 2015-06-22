-module(model_privatechat).

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