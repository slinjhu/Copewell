function mapdraw(container, datafile, title, min, max){
    var datamap;
    var map = new Choropleth(container);

    queue()
    .defer(d3.json, 'js/us-counties.json')
    .defer(d3.csv, datafile)
    .await(function(err, json, csv){
        var countydata = new CountyData(csv, min, max);
        map.loadMap(json, countydata);
        map.addLegend(countydata);
        d3.select(container)
        .insert('p', ":first-child")
            .style('text-align', 'center')
            .style('font-size', '18pt')
        .html(title);
    });
}

var Choropleth = function(container){
    this.container = container;
    
    this.width = 1000;
    this.height = 580;
}

Choropleth.prototype.loadMap = function(jsondata, countydata){
    d3.select(this.container).html('');
    var projection = d3.geo.albersUsa().scale(1200).translate([this.width / 2, this.height / 2]);
    var path = d3.geo.path().projection(projection);
    var svg = d3.select(this.container).append("svg")
    .attr("width", this.width)
    .attr("height", this.height);

    svg.append("g")
    .selectAll("path")
    .data(topojson.feature(jsondata, jsondata.objects.counties).features)
    .enter().append("path")
    .style('stroke', '#777')
    .style('fill', function(feature){
        return countydata.getColor(feature.id);
    })
    .attr("d", path);
}
Choropleth.prototype.addLegend = function(countydata){
    var ticks = [];
    var num = 10;
    for(var i = 0; i <= num; i++){
        ticks[i] = countydata.min + (countydata.max - countydata.min) * i / num;
    }

    d3.select(this.container).selectAll('ul').remove();
    var legend = d3.select(this.container).insert('ul', ":first-child").style('list-style-type', 'none');
    var keys = legend.selectAll('li.key').data(ticks);

    keys.enter().append('li')
    .style('float', 'left')
    .style('border-top-width', '15px')
    .style('border-top-style', 'solid')
    .style('font-size', '140%')
    .style('width', '80px')
    .style('border-top-color', function(d){
        return countydata.valueToColor(d);
    })
    .text(function(d) {return parseFloat(d.toFixed(2));});
}


var CountyData = function(csvdata, min, max){
    datamap = d3.map();
    csvdata.forEach(function(d){
        datamap.set(d.fips, +d.value);
    });
    if(typeof max !== 'undefined'){
        this.max = max;
    }else{
        this.max = d3.max(datamap.values());
    }
    if(typeof min !== 'undefined'){
        this.min = min;
    }else{
        this.min = d3.min(datamap.values());
    }

}

CountyData.prototype.getColor = function(fips){
    var value = datamap.get(fips);
    return this.valueToColor(value);
}

CountyData.prototype.valueToColor = function(value){
    if(isNaN(value)){
        return 'none';
    }else{
        var normal = (value - this.min) / (this.max - this.min);
        var hue = Math.round(255 * (1-normal));
        var color = d3.hsl(hue, 1, 0.5);
        return color.toString();
    }
}


