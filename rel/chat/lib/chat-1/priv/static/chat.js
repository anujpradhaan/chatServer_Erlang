var socket;

function add_message(message) {
    $('#messages').append('<p></p>').children().last().text(message);
}

function add_message_chatwindow(message){
    $(".activechatroom").append("<p>"+message+"</p>");
}
function read_message_input() {
    return $('#message').val();
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
        add_message_chatwindow(event.data);
    };

    socket.onclose = function() {
        add_message("Connection closed.");
    };
}

function setSessionInfo(username){
    if(typeof(Storage) !== "undefined") {
        sessionStorage.username =username;
        $("#LogInUser").text(sessionStorage.username); 
        connect_to_chat();
    } else {
        add_message("WebStorage Is not compatible");
    }
}

function send_message(e) {
    var message = read_message_input();
    var browserSideMessage=message;
    if(typeof(Storage) !== "undefined"){

       var username = "";
       if(sessionStorage.username){
            username=sessionStorage.username;
            message=username+":"+message;
            browserSideMessage=username+":"+browserSideMessage;
       }
       var chatroom = "";
       if(sessionStorage.activechatroom){
            chatroom=sessionStorage.activechatroom;
            message=chatroom+":"+message
       }

    }
    //#add_message_chatwindow(message);
    /*Socket's send method is used to pass the information to the server*/
    socket.send(browserSideMessage);
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
      $("#LogInUser").text(sessionStorage.username);
      
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
    if(alreadyLoggedIn()){
        connect_to_chat();
    } 
    $('#send-button').click(send_message);
})
