
function setup_color_callbacks(){
   ["a", "b"].forEach(function(i){
     $("#color_" + i).bind("click", function() {
       selected_favorite_color(i);
     });
   });
}

function reset_favorite_colors(){
  $("#favorite_colors").html('');
}

function add_favorite_color(color){
  $("#favorite_colors").append("<div class=\"mini_color\" id=\"newly_added\"/>");
  $("#newly_added").css("background-color", color).removeAttr("id");
}

function load_initial_colors(){
  $("#color_b").css("background-color", "red");
  $("#color_a").css("background-color", "green");
}


function selected_favorite_color(clicked) {
  add_favorite_color($("#color_" + clicked).css("background-color"));
}
