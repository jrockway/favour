
var favour_jsorb = new JSORB.Client ({
    base_url: "http://localhost:3000/jsorb/",
    base_namespace: ""
});

function call(req, callback){
    favour_jsorb.call(favour_jsorb.new_request(req), callback);
}

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

function opposite_of(a_or_b){
    switch(a_or_b){
        case "a":
            return "b";
        case "b":
        default:
            return "a";
    }
}

function selected_favorite_color(clicked) {
    var good = $("#color_" + clicked).css("background-color");
    var bad  = $("#color_" + opposite_of(clicked)).css("background-color");
    call(
        {
            method: '/favour/controller/color/add_color_pair',
            params: [
                {
                    good: good,
                    bad: bad
                }
            ]
        },
        load_next_colors
    );
}

function load_next_colors(){
    alert("loading next colors");
}
