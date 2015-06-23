-module(chatbox_handler).

-compile(export_all).

init({tcp,http},Req,Opts) ->
	{Method,Req2} =cowboy_req:method(Req),
	Req3 = returnForm(Method,Req),
	{ok,Req2,Opts}.

returnForm(<<"GET">>,Req) ->
	cowboy_req:reply(200,[],
		<<"<div class='mainWrapper'>
	  <div>
		<h2>
			Chat Application: ChatNow
		</h2>
		<div id='logoutdiv'>
			<h3 id='LogInUser'>

			</h3>
			<input type='button' value='LogOut'  id='logoutButton' />
		</div>
		<h3 id='messages'>

		</h3>
	</div>
    <table>
		<tr>
			<td>
				<div class='chatroombox borderBlack' >
					
				</div>
			</td>
			<td>
				<table>
					<tr>
						<td>
							<input type='button' id='latestListofChatRooms' value='Refresh Chatroom List' />
							<input type='button' id='joinchatroombutton' value='Join This Chat Room' />
 						</td>
 					</tr>
 					<tr>
 						<td>
							<form action='addnewchatroom' method='post' id='addChatRoomForm'>
								<input type='text' name='newroomname' id='newChatRoomName'/>
								<input type='hidden' name='username' id='username' value='' />
								<input type='button' id='addNewChatRoomButton' value='Add New Chat Room' />
							</form>
						</td>
					</tr>
					<tr>
						<td>
							<input type='button' value='Reset' id='resetButton'/>
 						</td>
 					</tr>
				</table>
			</td>
		</tr>
    </table>
    <br>
    <br>
    <table>
		<tr>
			<td>
				<div>
				Currently Active Chatroom is :
					<h2 id='showActiveChatroom'>
						Default
					</h2>
				</div>
			</td>
			<td>
				<div>
					<h2>
						Active Users 
					</h2>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				
				<div class='activechatroom borderBlack' >
					
				</div>
				<br>
				<div>
					<table>
						<tr>
							<td>
								<input type='text' id='message'/>
							</td>
							<td>
								<input type='button'  id='send-button' value='send'/>
								<input type='button' value='Clear' id='clearChatBox'/>
							</td>
						</tr>
					</table>
				</div>
			</td>
			<td>
				<div class='activechatroomusers borderBlack' >
					<p>
						User1
					</p>
					<p>
						User2
					</p>
					<p>
						User3
					</p>
				</div>
				<br>
				<div>
					<table>
						<tr>
							<td>
								<input type='button' value='Chat Privetely'/>
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
    </table>
</div>">>,
		Req).