function Clear(){
	$(".option").remove();
}

function OnCreate(name, id) {
	$("#ui").attr('ui_id', id);
	$("#title").text(name);
}


function InsertOption(id, title, description, button_text){
	$(".container").append('<div class="option"><div class="optionTitle"><h1>'+title+'</h1><label>'+description+'</label></div><div class="optionButton"><div onclick="OnOptionClick(this)" option="'+id+'" id="optionBtn" class="optionBtn"><h1>'+button_text+'</h1></div></div></div>');
}


function OnOptionClick(e){
	var id 		= $("#ui").attr('ui_id');
	var option 	= $(e).attr('option');

	CallEvent("KUI:OptionPressed", id, option);
	playClick();
}

function playClick(){
	var audio = new Audio('http://asset/kuz_UI/utils/click.wav');
	audio.play();
}

(function(obj)
	{
		ue.game = {};
		ue.game.callevent = function(name, ...args)
		{
			if (typeof name != "string") {
				return;
			}

			if (args.length == 0) {
				obj.callevent(name, "")
			}
			else {
				let params = []
				for (let i = 0; i < args.length; i++) {
					params[i] = args[i];
				}
				obj.callevent(name, JSON.stringify(params));
			}
		};
	})(ue.game);
CallEvent = ue.game.callevent;