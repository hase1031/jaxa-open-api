/**
 * Created by Ryusuke_Chiba on 2/9/14.
 */
var map;
var infowindow;
function initialize() {
    var mapOptions = {
        zoom: 2,
        center: new google.maps.LatLng(0, 0)
    };
    map = new google.maps.Map(document.getElementById('map-canvas'),
        mapOptions);

    // 選択できる地点の表示
    var place_choices = [
        {
            'position': new google.maps.LatLng(61.13666666, 99.23861111),
            'place_name': 'Siberia'
        },
        {
            'position': new google.maps.LatLng(23.97805555, 11.43638888),
            'place_name': 'The Sahara'
        },
        {
            'position': new google.maps.LatLng(7.12222222, -73.19500000),
            'place_name': 'Colombia'
        },
        {
            'position': new google.maps.LatLng(39.26722222, 141.19527777),
            'place_name': 'Japan Iwate'
        },
        {
            'position': new google.maps.LatLng(-81.10861111, -133.73000000),
            'place_name': 'Antarctic'
        },
        {
            'position': new google.maps.LatLng(31.58972222, -100.65277777),
            'place_name': 'the U.S. Texas'
        },
        {
            'position': new google.maps.LatLng(43.67833333, 39.92638888),
            'place_name': 'Russia sochi'
        },
        {
            'position': new google.maps.LatLng(69.43666666, 88.37055555),
            'place_name': 'Russia Norilsk'
        },
        {
            'position': new google.maps.LatLng(-34.04944444, 151.26749999),
            'place_name': 'Australia Sydney'
        },
        {
            'position': new google.maps.LatLng(51.64000000, 0.27027777),
            'place_name': 'England London'
        },
        {
            'position': new google.maps.LatLng(-1.47472222, 36.86388888),
            'place_name': 'Kenya nairobi'
        },
    ];

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
            position: place_choices[i].position,
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
