/**
 * Created by Ryusuke_Chiba on 2/9/14.
 */
var map;
var infowindow;
var place_choices = gon.place_choices;
var marker = [];

function initialize() {
    var mapOptions = {
        zoom: 2,
        center: new google.maps.LatLng(30, 0)
    };
    map = new google.maps.Map(document.getElementById('map-canvas'),
        mapOptions);

    // show infowindow and select the place in form when marker clocked
    function attachEvent(marker, msg) {
        google.maps.event.addListener(marker, 'click', function() {
            if (infowindow) {
                infowindow.close();
            }
            infowindow = new google.maps.InfoWindow({
                content: msg
            });
            infowindow.open(marker.getMap(), marker);

            $('select#place_id').val(marker.place_id);
        });
    }

    // attach event to every place
    for (var i = 0; i < place_choices.length; i++) {
        marker[i] = new google.maps.Marker({
            position: new google.maps.LatLng(place_choices[i].lat, place_choices[i].lon),
            map: map,
            title: place_choices[i].place_name,
            place_id: place_choices[i].place_id
        });

        attachEvent(marker[i], place_choices[i].place_name);
    }

    google.maps.event.addListener(map, 'click', function() {
        infowindow.close();
    });
}

google.maps.event.addDomListener(window, 'load', initialize);

$(function() {
    // click the place's marker when the place selected in form
    $('#place_id').on('change', function(e) {
        var place_id = $(this).children('option:selected').val();
        google.maps.event.trigger(marker[place_id], 'click');
    });
})
