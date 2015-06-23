-module(login_form_handler).

-compile(export_all).

init({tcp,http},Req,Opts) ->
	{Method,Req2} =cowboy_req:method(Req),
	Req3 = returnForm(Method,Req),
	{ok,Req2,Opts}.

returnForm(<<"GET">>,Req) ->
	cowboy_req:reply(200,[],
		<<"<div id='loginForm' class='' title='Login'>
		
		<form id='formLogin' method='post' action='login'> 
		<table>
		  	<tr>
		  		<td>
		  			Username:
		  		</td>
		  		<td>
		  			<input type='text'  id='username' name='username'/>
		  		</td>
		  	</tr>
		  	<tr>
		  		<td>
		  			Password:
		  		</td>
		  		<td>	
		  			<input type='password' id='password' name='password' />
		  		</td>	
			</tr>
			<tr>
		  		<td>
		  			
		  		</td>
		  		<td>
		  			<input type='button'  id='loginMe' class='loginMe' value='Login'/>
		  		</td>
		  	</tr>
		</table>
	  </form></div>">>,
		Req).

