function UpdateData(money, bank, role, level, experience) {
	
	var role = role.charAt(0).toUpperCase() + role.slice(1);


	var str = '$' + parseInt(money).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
    var newStr = str.substring(0, str.length - 3);
    
    $("#money").text(newStr);

    var str = '$' + parseInt(bank).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
    var newStr = str.substring(0, str.length - 3);
    
    $("#bank").text(newStr);



	$('#role').text(role);
	$('#level').text('Level ' + level);
	var xpPercentage = experience / (level * (level/2) * 50) * 100;
	if(xpPercentage > 100){
		xpPercentage = 100;
	}
	$('#levelBar').css("width", xpPercentage + "%");
	$('#container').css('transform', "translate(0%, 0px)");

}
function hideJob(){
	$(".role").hide();
}
function hideLevel(){
	$(".level").hide();
}



function SetVehicleSpeed(speed, rpm) {
	var speed = Math.abs(speed) / 1.609;
	$(".speed").css("transform", "rotate("+ (speed + 39) +"deg)");
	$(".rpm").css("transform", "rotate("+ ((rpm / 37) + 33) +"deg)");

	//$('#speed').text(speed);
	$('#rpm').text(rpm);
}

function ToggleSpeedo(bool){
	if(bool){
		$(".speedo").fadeIn(400).css("display","flex");;
	}else{
		$(".speedo").fadeOut(400);
	}
}

function ToggleScoreboard(bool){
	if(bool){
		$(".scoreboard_main").fadeIn(200);
	}else{
		$(".scoreboard_main").fadeOut(150);
	}
}

function SetServerName(name) {
	$('#servername').html(name);
}

function SetPlayerCount(count, max) {
	$('#playercount').text(count + " / " + max);
}

function RemovePlayers() {
	$('.player').remove();
}

function AddPlayer(id, name, job, ping) {

	var color = "#555555";
	if(ping < 50){
		color = "#63f250";
	}else if(ping < 75){
		color = "#f2ef50";
	}else if(ping < 125){
		color = "#f29c50";
	}else{
		color = "#f25050";
	}

	var job_ = job.charAt(0).toUpperCase() + job.slice(1) 
	$('#playertable').append('<tr class="player"><td>'+id+'</td><td>'+name+'</td><td>'+job_+'</td><td><div style="background: '+color+'" class="ping"></div></td></tr>');
}



function ToggleAnimations(bool) {
	if(bool){
		$(".animations").fadeIn(50);
	}else{
		$(".animations").fadeOut(30);
	}
}

function ShowVipAnimations(){
	$(".vip").show();
}

function PlayAnimation(anim){
	$(".anim-sub-menu").css("height", "0vh");
	CallEvent("Kuzkay:PlayAnim",anim);
}

$(document).ready(function(){
	$(".anim-category").mouseover(function(e){
		$(".anim-sub-menu").css("height", "0vh");
		$(this).find('.anim-sub-menu').css("height", "100vh");
	});
});




















function ToggleGarage(bool) {
	if(bool){
		$(".garage").show();
	}else
	{
		$(".garage").hide();
	}
}

function InsertVehicle(id, model, car_name, plate){
  
  $(".gar-container").append('<div id="'+id+'" vehicle_id="'+id+'" vehicle_model="'+model+'" vehicle_plate="'+plate+'" class="item"><div class="itemName"><h1>'+car_name+'</h1></div><div class="itemPlate"><img class="plateImg" src="http://asset/kuz_Garage/gui/img/plate.png"><h1>'+plate+'</h1></div><div class="itemOptions"><img src="http://asset/kuz_Garage/gui/img/take.png" onclick="TakeOut(this)" id="takeBtn" title="Take out vehicle" class="itemBtn"><img src="http://asset/kuz_Garage/gui/img/locate.png" onclick="Locate(this)" id="locateBtn" title="Locate vehicle" class="itemBtn"><img src="http://asset/kuz_Garage/gui/img/store.png" onclick="Store(this)" id="locateBtn" title="Store vehicle" class="itemBtn"></div></div>');

}

function UpdateColor(id, bool)
{
  if(bool == "in"){
    $("#" + id).css("background", "linear-gradient(90deg, rgba(55,55,55,1) 0%, rgba(110,110,110,1) 100%)");
  }else{
    $("#" + id).css("background", "linear-gradient(90deg, rgba(70,55,55,1) 0%, rgba(130,110,110,1) 100%)");
  }
}

function TakeOut(e){
  var plate   = $(e).parent().parent().attr("vehicle_plate");
  var id    = $(e).parent().parent().attr("vehicle_id");
  CallEvent("Kuzkay:GarageTakeOut", plate, id);
  playClick();
}
function Store(e){
  var plate   = $(e).parent().parent().attr("vehicle_plate");
  var id    = $(e).parent().parent().attr("vehicle_id");
  CallEvent("Kuzkay:GarageStore", plate, id);
  playClick();
}
function Locate(e){
  var plate   = $(e).parent().parent().attr("vehicle_plate");
  var id    = $(e).parent().parent().attr("vehicle_id");
  CallEvent("Kuzkay:GarageLocate", plate, id);
  playClick();
}


function playClick(){
  var audio = new Audio('http://asset/kuz_Garage/sounds/click.wav');
  audio.play();
}