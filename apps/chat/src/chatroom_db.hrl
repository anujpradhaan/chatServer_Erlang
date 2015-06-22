-record(chatrooms,{
%	id, %%Primary Key for the table
	name, %%Name of the chatroom
	created_by, %%Username of the user created the chatroom
	active %%Check the status of chatroom. If active then only consider it
}).

-record(users,{
%	id, %%Primary Key of the table
	username, %%username provided  by the user
	password, %%password for the user account
	dob, %%Date of birth of the user
	country,
	full_name, %%Name given by the user
	email,
	type, %%Type of user, 1 = general user, 2= admin,
	active %% Check the status of user. If active then only use it.
}).

-record(chathistory,{
%	id, %%Primary key for the table
	message, %%message sent during the chat
	chatroom, %% Chatroom for this message
	username, %% Username of the user who sent the message
	timestamp %% Time of generation of the message
}).

-record(privatechat,{
%	id, %%Primary key for the table
	message, %% message sent during the chat
	senderusername, %% sender of the message
	receiverusername, %%receiver of the message
	timestamp %% Time of generation of the message
}).