$(function(){

$("#modal_open").click(function(){

   $("body").append('<div id="modal_overlay"></div>');
   $("#modal_overlay").fadeIn("slow");
   centeringModal();

   $("#modal_window").fadeIn("slow");

   $("#modal_overlay,.modal_close").unbind().click(function(){

      $("#modal_window,#modal_overlay").fadeOut("slow",function(){
         $('#modal_overlay').remove();
      });

   });

});

$(window).resize(centeringModal);

	function centeringModal(){

	   var w = $(window).width();
	   var h = $(window).height();

	   var cw = $("#modal_window").outerWidth({margin:true});
	   var ch = $("#modal_window").outerHeight({margin:true});

	   $("#modal_window").css({"left": ((w - cw)/2) + "px","top": ((h - ch)/2) + "px"})

	}

});

function check() 
{
  if(/^[a-zA-Z]+$/.test(document.modal_submit.team_name.value)){
    
    return true;
  }
alert('team name is only A~Z and a~z');
return false;
}

function team_name_cookie_submit(){
    date1 = new Date();
//5時間後の日付データを作成
    date1.setTime(date1.getTime() + 5*60*60*1000);
//GMT形式に変換して変数date2に格納する
    date2 = date1.toGMTString();
    document.cookie=document.modal_submit.team_name.value+";expires="+ date2;
}
function get_team_name_cookie(){
    'use strict';
    var tako=document.cookie;
    document.modal_submit.team_name.value=document.cookie;
}
window.onload=function(){
    'use strict';
    get_team_name_cookie();
};
