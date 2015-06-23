-module(signup_form_handler).

-compile(export_all).

init({tcp,http},Req,Opts) ->
	{Method,Req2} =cowboy_req:method(Req),
	Req3 = returnForm(Method,Req),
	{ok,Req2,Opts}.

returnForm(<<"GET">>,Req) ->
	cowboy_req:reply(200,[],
		<<"<div id='signUpForm' class='' title='SignUp'>
	  	<form id='formSignUp' method ='post' action='signup'>
	  <table>
	  		<tr>
		  		<td>
		  			Email:
		  		</td>
		  		<td>
		  			<input type='email' name='email'  id='email' />
		  		</td>
		  	</tr>
		  	<tr>
		  		<td>
		  			Username:
		  		</td>
		  		<td>
		  			<input type='text'  id='username' name='username' />
		  		</td>
		  	</tr>
		  	<tr>
		  		<td>
		  			Password:
		  		</td>
		  		<td>	
		  			<input type='password' id='password' name='password'/>
		  		</td>	
			</tr>
			<tr>
		  		<td>
		  			Confirm Password:
		  		</td>
		  		<td>
		  			<input type='password'  id='confirmpassword' name='confirmpassword'/>
		  		</td>
		  	</tr>
		  	<tr>
		  		<td>
		  			DOB:
		  		</td>
		  		<td>
		  			<input type='date'  id='dob' name='dob'/>
		  		</td>
		  	</tr>
		  	<tr>
		  		<td>
		  			Country:
		  		</td>
		  		<td>
		  			<input type='text'  id='country' name='country'/>
		  		</td>
		  	</tr>
		  	<tr>
		  		<td>
		  			
		  		</td>
		  		<td>
		  			<input type='button'  id='signMe' class='signMe' value='SignUp'/>
		  		</td>
		  	</tr>
		</table>
	  </form></div>">>,
		Req). 

