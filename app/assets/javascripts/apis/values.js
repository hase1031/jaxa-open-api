var place_a_res = gon.place_a_res;
var place_b_res = gon.place_b_res;
var place_a_data = gon.place_a_data;
var place_b_data = gon.place_b_data;
var place_data_len_min = Math.min(place_a_res.length, place_b_res.length);

function drawChart(data_type, data_name) {
    var graph_data = [];
    graph_data.push(['date', place_a_data.place_name, place_b_data.place_name]);
    for (var i = 0; i < place_data_len_min; i++) {
        if (!place_a_res[i][data_type]) {
            place_a_res[i][data_type] = 0;
        }
        if (!place_b_res[i][data_type]) {
            place_b_res[i][data_type] = 0;
        }
        var short_format_date = place_a_res[i].date.substring(5);
        graph_data.push([short_format_date, place_a_res[i][data_type], place_b_res[i][data_type]]);
    }
    var data = google.visualization.arrayToDataTable(graph_data);

    var options = {
        title: data_name
    };

    var chart = new google.visualization.LineChart(document.getElementById(data_type + '-chart-div'));
    chart.draw(data, options);
}

function drawTemperature(place_a_data, place_b_data, season_a_id, season_b_id) {
    var graph_data = [];
    graph_data.push(['date', place_a_data.place_name, place_b_data.place_name]);
    for (var i = 0; i < 3; i++) {
        var month_a = ((season_a_id) * 3 + (i + 1)) % 12;  // season_id : 0 は2月から始まる（ここでは 0 origin で扱う）
        var month_b = ((season_b_id) * 3 + (i + 1)) % 12;
        var display_month = ['1st', '2nd', '3rd'];
        graph_data.push(
            [
                display_month[i],
                place_a_data.temperature[month_a]['degree'],
                place_b_data.temperature[month_b]['degree']
            ]
        );
    }
    var data = google.visualization.arrayToDataTable(graph_data);

    var options = {
        title: 'temperature (℃)'
    };

    var chart = new google.visualization.LineChart(document.getElementById('temperature-chart-div'));
    chart.draw(data, options);
}

google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(function() {
    drawChart('prc', 'rainfall precipitation (mm/day)');
    drawChart('smc', 'soil water content (%)');
    drawChart('snd', 'depth of snow (cm)');
    drawTemperature(place_a_data, place_b_data, gon.season_a_id, gon.season_b_id);
});


function initializeMap() {
    var mapOptions = {
        zoom: 1,
        center: new google.maps.LatLng(50, 0)
    };
    var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

    var marker = [];
    function makeMarkerAndInfoWindow(place_data, id) {
        marker[id] = new google.maps.Marker({
            position: new google.maps.LatLng(place_data.lat, place_data.lon),
            map: map,
            title: place_data.place_name,
            place_id: place_data.place_id
        });
        new google.maps.InfoWindow({
            content: place_data.place_name,
            disableAutoPan: true
        }).open(marker[id].getMap(), marker[id]);
    }

    makeMarkerAndInfoWindow(place_a_data, 1);
    makeMarkerAndInfoWindow(place_b_data, 2);
}

google.maps.event.addDomListener(window, 'load', initializeMap);
