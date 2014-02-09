/**
 * Created by Ryusuke_Chiba on 2/9/14.
 */
var map;
var infowindow;
var place_choices = gon.place_choices;
function initialize() {
    var mapOptions = {
        zoom: 2,
        center: new google.maps.LatLng(0, 0)
    };
    map = new google.maps.Map(document.getElementById('map-canvas'),
        mapOptions);

    function attachEvent(marker, msg) {
        google.maps.event.addListener(marker, 'click', function() {
            if (infowindow) {
                infowindow.close();
            }
            infowindow = new google.maps.InfoWindow({
                content: msg
            });
            infowindow.open(marker.getMap(), marker);
        });
    }

    for (var i = 0; i < place_choices.length; i++) {
        var marker = new google.maps.Marker({
            position: new google.maps.LatLng(place_choices[i].lat, place_choices[i].lon),
            map: map,
            title: place_choices[i].place_name
        });

        attachEvent(marker, place_choices[i].place_name);
    }

    google.maps.event.addListener(map, 'click', function() {
        infowindow.close();
        $("#btn_hide").attr("disabled", "disabled");
        $("#btn_show").attr("disabled", false);
    });
}

google.maps.event.addDomListener(window, 'load', initialize);
