var socket;

function add_message(message) {

    $('#container #messages').append('<p></p>').children().last().text(message);
}

function add_message_chatwindow(message){
    $("#container .activechatroom").append("<p>"+message+"</p>");
}

function read_message_input() {
    return $('#container #message').val();
}

/*Function to store the active chatroom in the WebStorage*/
function storeTheActiveChatRoom(chatroom){
    if(typeof(Storage) !== "undefined") {
        sessionStorage.activechatroom = chatroom;
    } else {
        add_message("WebStorage Is not compatible");
    }
}

/*Function to store the userdetails in the session*/
function storeUserDetails(username){
    if(typeof(Storage) !== "undefined"){
        sessionStorage.username = username;
    }else{
        add_message("WebStorage is not compatible");
    }
}

function connect_to_chat() {

    socket = new WebSocket("ws://localhost:8080/ws");

    socket.onopen = function() {
        add_message("Connected.")
    };

    /*Sockets receives data from the server on onmessage event*/
    socket.onmessage = function(event) {
        var msg=event.data;
        var chatRoom=msg.split(":");
        var currentlyActiveChatRoom = $("#currentlyActiveChatRoom").val().trim();
        if(currentlyActiveChatRoom === chatRoom[0].trim())
            add_message_chatwindow(chatRoom[1]+":"+chatRoom[2]);
    };

    socket.onclose = function() {
        add_message("Connection closed.");
    };
}

function setSessionInfo(){
    if(typeof(Storage) !== "undefined") {
        //sessionStorage.username =username;
        //$("#LogInUser").text(sessionStorage.username); 
        $.ajax({
        url:"availableChatRooms",
        type:"GET",
        data: "",
        success: function  (data,textStatus,jqXHR) {
            if((jqXHR.status==200 || jqXHR.status=="200") && data !=""){
                var rooms=data;
                rooms=rooms.split(",");
                $("#container .chatroombox").text("");
                for (i = 0;i < rooms.length; i++) { 
                    $("#container .chatroombox").append("<p>"+rooms[i]+"</p>");
                }
            }else if(data ==""){
                alert("No Chat rooms exists");
            }else{
                alert("Unable to Fetch the chatrooms");
            }   
        },
        error: function (jqXHR,textStatus,error){
            alert("Error!!!, Try again later");
        }
        });
        /*Hide the login signup panel*/
        $("#dialog-confirm").hide();
        connect_to_chat();
    } else {
        add_message("WebStorage Is not compatible");
    }
}

function send_message(e) {
    var message = read_message_input();
    var username=$("#container #username").val();
    add_message_chatwindow(username+":"+message);
    /*Socket's send method is used to pass the information to the server*/
    var activeChatWindow=$("#currentlyActiveChatRoom").val();
    socket.send(activeChatWindow+":"+username+":"+message);
    $('#message').val("");
}

function removeSessionInfo(){
    if(sessionStorage.username){
        sessionStorage.username=null;
   }
}

function showLoginButtonPanel(){
    $("#dialog-confirm").show();
    $(".mainWrapper").hide();
}

function alreadyLoggedIn(){
    alert(sessionStorage.username);
    if(sessionStorage.username && (sessionStorage.username != "null")) {
      $("#container #LogInUser").text(sessionStorage.username);
      
      return true;  
   }else{
    return false;
   }
}
function openLoginWindow(){
    $("#dialog-confirm").show();
    $(".mainWrapper").hide();   
}
$(document).ready(function() {
    /*Add a authentication mechanism here so that user can provide login information here
      If the information is correct and available in the DB then only allow him to chat otherwise ask him to signup
    */
    /*
    The login will work till the window is open. 
    Once the window is closed, You need to login again.
    */
/*    if(alreadyLoggedIn()){
        connect_to_chat();
    }*/

    /*Fetch All the ChatRooms available*/
    $(document).on('click',"#container #latestListofChatRooms",function(){
        $.ajax({
        url:"availableChatRooms",
        type:"GET",
        data: "",
        success: function  (data,textStatus,jqXHR) {
            if((jqXHR.status==200 || jqXHR.status=="200") && data !=""){
                var rooms=data;
                rooms=rooms.split(",");
                $("#container .chatroombox").text("");
                for (i = 0;i < rooms.length; i++) { 
                    $("#container .chatroombox").append("<p>"+rooms[i]+"</p>");
                }
            }else if(data ==""){
                alert("No Chat rooms exists");
            }else{
                alert("Unable to Fetch the chatrooms");
            }   
        },
        error: function (jqXHR,textStatus,error){
            alert("Error!!!, Try again later");
        }
        });        
    });
    $(document).on('click',"#container #send-button",send_message);

    /*Select a Chat Room*/
    $(document).on("click","#container #joinchatroombutton",function(){
        //alert($("#container .chatroombox .yellow").text());
       var room=$("#container .chatroombox .yellow").text().trim();
       $("#currentlyActiveChatRoom").val(room); 
       $("#container #showActiveChatroom").text(room);
       $("#container .activechatroom").text("");
    });

    /*Reset Button */
    
    $(document).on("click","#container #resetButton",function(){
        $("#container .activechatroom").text("");
        $("#currentlyActiveChatRoom").val("default"); 
        $("#container #showActiveChatroom").text("Default");       
    });
    /*Clear Chat Box*/
    $(document).on("click","#container #clearChatBox",function(){
        $("#container .activechatroom").text("");      
    });

    $(document).on("click","#container #addNewChatRoomButton",function(){
       var formData=$("#container #addChatRoomForm").serialize();
       var roomname=$("#container #newChatRoomName").val();
       var username=$("#container #username").val();
       //socket.send("newroom"+","+roomname+","+username);
       $.ajax({
            url:"addnewchatroom",
            type:"POST",
            data: formData,
            success: function  (data,textStatus,jqXHR) {
                if((jqXHR.status==200 || jqXHR.status=="200") && data==="Done"){
                    $("#container .chatroombox").append("<p>"+roomname+"</p>");
                }else{
                    alert("Wrong Username Password Combination");
                }   
            },
            error: function (jqXHR,textStatus,error){
                alert("Error!!!, Try again later or Try changing your room name");
            }
        });
    });    
})
