function click_Myfriend_btn(){
    var my_friend = document.getElementsByClassName("my_friend");
    var message = document.getElementsByClassName("message");
    var for_searching = document.getElementsByClassName("for_searching");
    var classifier_friend_btn = document.getElementsByClassName("classifier_friend_btn");
    var find_input_field = document.getElementsByClassName("find_input_field");
    
    for(var i=0; i<my_friend.length; i++){
        my_friend[i].style.display="block"
    }
    
    for(var j=0; j<classifier_friend_btn.length; j++){
        classifier_friend_btn[j].classList.remove("friend_active_btn");
    }
    
    for(var a=0; a<message.length; a++){
        message[a].style.display="none"
    }
    for(var b=0; b<for_searching.length; b++){
        for_searching[b].style.display="none"
    }
    
    classifier_friend_btn[0].classList.add("friend_active_btn");
    find_input_field[0].style.display="none";
}

function click_message_btn(){
    var my_friend = document.getElementsByClassName("my_friend");
    var message = document.getElementsByClassName("message");
    var for_searching = document.getElementsByClassName("for_searching");
    var classifier_friend_btn = document.getElementsByClassName("classifier_friend_btn");
    var find_input_field = document.getElementsByClassName("find_input_field");
    
    for(var i=0; i<message.length; i++){
        message[i].style.display="block"
    }
    
    for(var j=0; j<classifier_friend_btn.length; j++){
        classifier_friend_btn[j].classList.remove("friend_active_btn");
    }
    
    for(var a=0; a<my_friend.length; a++){
        my_friend[a].style.display="none"
    }
    for(var b=0; b<for_searching.length; b++){
        for_searching[b].style.display="none"
    }
    
    classifier_friend_btn[1].classList.add("friend_active_btn");
    find_input_field[0].style.display="none";
}

function click_find_btn(){
    var my_friend = document.getElementsByClassName("my_friend");
    var message = document.getElementsByClassName("message");
    var classifier_friend_btn = document.getElementsByClassName("classifier_friend_btn");
    var find_input_field = document.getElementsByClassName("find_input_field");
    
    for(var j=0; j<classifier_friend_btn.length; j++){
        classifier_friend_btn[j].classList.remove("friend_active_btn");
    }
    
    for(var a=0; a<message.length; a++){
        message[a].style.display="none"
    }
    for(var b=0; b<my_friend.length; b++){
        my_friend[b].style.display="none"
    }
    
    classifier_friend_btn[2].classList.add("friend_active_btn");
    find_input_field[0].style.display="block";
}