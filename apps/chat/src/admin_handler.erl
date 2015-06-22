-module(admin_handler).

-compile(export_all).

-include("chatroom_db.hrl").

%%This function will reset the entire database
reset() ->
	mnesia:stop(),
	mnesia:delete_schema([node()]),
	mnesia:create_schema([node()]),
	mnesia:start().

%%This Function creates all the table required for the CHAT database
init() -> 
	mnesia:create_table(chatrooms,[{attributes,record_info(fields,chatrooms)},{disc_copies,[node()]}]),
	mnesia:create_table(users,[{attributes,record_info(fields,users)},{disc_copies,[node()]}]),
	mnesia:create_table(chathistory,[{attributes,record_info(fields,chathistory)},{disc_copies,[node()]}]),
	mnesia:create_table(privatechat,[{attributes,record_info(fields,privatechat)},{disc_copies,[node()]}]).

%%This function permanently deletes all entries in table Table variable.
clear_table(Table) ->
	mnesia:clear_table(Table).

