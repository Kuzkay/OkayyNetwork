function SendNotification(text, color){
	var num = $('.notification').length + 1;

	$(".notificationsBox").prepend('<div><div id="'+num+'" style="transition-duration: 2s;" class="notification"><h1 class="notificationText">'+text+'</h1></div></div>');
	$('#'+num).css('border-left', '15px solid ' + color);

	

	$('#'+ num)
	  .delay(250)
	  .queue(function (next) {
	  	$(this).css('transition-duration', "0.3s"); 
	    $(this).css('height', "6%");
	    $(this).css('margin-top', "5%");
	    $(this).css('margin-bottom', "5%"); 
	    next(); 
	  });

	var audio = new Audio('http://asset/kuz_Notifications/sounds/notification.wav');
	audio.play();

	$('#'+ num)
	  .delay(300)
	  .queue(function (next) { 
	  	$(this).css('transition-duration', "1s"); 
	    $(this).css('transform', "translate(0%, 0px)"); 
	    next(); 
	  });
	$('#'+ num)
	  .delay(6000)
	  .queue(function (next) { 
	  	$(this).css('transition-duration', "1.5s"); 
	    $(this).css('transform', "translate(0%, 3000px)"); 
	    next(); 
	  });
	$('#'+ num)
	  .delay(1500)
	  .queue(function (next) { 
	  	$(this).remove(); 
	    next(); 
	  });
}
function HidePress(text){
	$(".pressNoti").fadeOut(250);
}
function SendPress(text){
	$(".pressText").html(text);
	$(".pressNoti").fadeIn(250);
}

function AddProgressBar(text, color_, id){
	var color = '#fafafa';
	if(color_ != null){ color = color_ }
	$(".progressBarsBox").append('<div id="bar_'+id+'" class="progressBar"><label>'+text.toUpperCase()+'</label><div class="progress" style="background-color: '+color+'; width: 0%; height: 100%; position: relative;"></div></div>');
}

function MoveProgressBar(id, percentage){
	$("#bar_" + id).find(".progress").css("width", percentage + "%");
}
function RemoveProgressBar(id){
	$("#bar_" + id).fadeOut(500, function(){ $(this).remove(); });
}
function SetProgressBarText(id, text){
	$("#bar_" + id).find("label").html(text.toUpperCase());
}