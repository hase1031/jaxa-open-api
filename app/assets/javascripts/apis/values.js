var place_a = gon.place_a;
var place_b = gon.place_b;
var place_a_name = gon.place_a_name;
var place_b_name = gon.place_b_name;
var place_data_len_min = Math.min(place_a.length, place_b.length);

function drawChart(data_type, data_name) {
    var graph_data = [];
    graph_data.push(['date', place_a_name, place_b_name]);
    for (var i = 0; i < place_data_len_min; i++) {
        if (!place_a[i][data_type]) {
            place_a[i][data_type] = 0;
        }
        if (!place_b[i][data_type]) {
            place_b[i][data_type] = 0;
        }
        var short_format_date = place_a[i].date.substring(5);
        graph_data.push([short_format_date, place_a[i][data_type], place_b[i][data_type]]);
    }
    var data = google.visualization.arrayToDataTable(graph_data);

    var options = {
        title: data_name
    };

    var chart = new google.visualization.LineChart(document.getElementById(data_type + '-chart-div'));
    chart.draw(data, options);
}

google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(function() {
    drawChart('prc', 'rainfall precipitation (mm/day)');
    drawChart('smc', 'soil water content (%)');
    drawChart('snd', 'depth of snow (cm)');
});
