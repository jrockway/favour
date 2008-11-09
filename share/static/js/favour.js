
var favour_jsorb = new JSORB.Client ({
    base_url: "http://localhost:3000/jsorb/",
    base_namespace: ""
});

function call(req, callback){
    favour_jsorb.call(favour_jsorb.new_request(req), callback);
}

function reset_favorite_colors(){
    $("#favorite_colors").html('');
}

function add_favorite_color(color){
    $("#favorite_colors").append("<div class=\"mini_color\" id=\"newly_added\"/>");
    $("#newly_added").css("background-color", color).removeAttr("id");
}

function set_colors(a, b){
    $("#color_a").css("background-color", a);
    $("#color_b").css("background-color", b);
}

function load_initial_colors(){
    set_colors("green", "red");
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

function enable_color_callbacks(){
    ["a", "b"].forEach(function(i){
        $("#color_" + i).bind("click", function() {
            selected_favorite_color(i);
        });
    });
}

function disable_color_callbacks(){
    ["a", "b"].forEach(function(i){
        $("#color_" + i).unbind("click");
    });
}

function selected_favorite_color(clicked) {
    disable_color_callbacks();

    var good = $("#color_" + clicked).css("background-color");
    var bad  = $("#color_" + opposite_of(clicked)).css("background-color");
    call(
        {
            method: '/favour/controller/color/add_color_pair',
            params: [good,bad],
        },
        function(){
            call(
                {
                    method: '/favour/controller/color/list_favorites',
                    params: [],
                },
                function(color_list){
                    reset_favorite_colors();
                    color_list.forEach(function(color){
                        add_favorite_color("#" + color);
                    });
                    call(
                        {
                            method: '/favour/controller/color/get_colors_to_compare',
                            params: [],
                        },
                        function(colors){
                            set_colors("#" + colors[0], "#" + colors[1]);
                            enable_color_callbacks(); // and the cycle begins again
                        }
                    );
                }
            );
        }
    );
}
