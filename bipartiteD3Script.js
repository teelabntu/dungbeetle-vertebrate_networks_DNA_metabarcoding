var data=[["Catharsius renaudpauliani","XROTU_36",3],
["Catharsius renaudpauliani","XROTU_40",1],
["Catharsius renaudpauliani","XROTU_10",1],
["Catharsius renaudpauliani","XROTU_07",2],
["Catharsius renaudpauliani","XROTU_32",2],
["Catharsius renaudpauliani","XROTU_28",1],
["Catharsius renaudpauliani","XROTU_34",1],
["Catharsius renaudpauliani","XROTU_05",1],
["Catharsius renaudpauliani","XROTU_04",2],
["Catharsius renaudpauliani","XROTU_02",9],
["Catharsius renaudpauliani","XROTU_19",1],
["Catharsius renaudpauliani","XROTU_39",1],
["Catharsius renaudpauliani","XROTU_16",1],
["Catharsius renaudpauliani","XROTU_21",2],
["Catharsius renaudpauliani","XROTU_08",1],
["Catharsius renaudpauliani","XROTU_23",1],
["Catharsius renaudpauliani","XROTU_03",1],
["Paragymnopleurus maurus","XROTU_03",1],
["Catharsius renaudpauliani","XROTU_12",1],
["Catharsius renaudpauliani","XROTU_01",9],
["Paragymnopleurus maurus","XROTU_01",2]]



 function sort(sortOrder){
                    return function(a,b){ return d3.ascending(sortOrder.indexOf(a),sortOrder.indexOf(b)) }
                  }
var color = {'Unlinked':'#3366CC','XROTU_02':'#FFCC66FF','XROTU_01':'#FFCC99FF','XROTU_04':'#FF9933FF','XROTU_05':'#664466FF','XROTU_03':'#99CCFFFF','XROTU_06':'#9999FFFF','XROTU_07':'#CC6699FF','XROTU_08':'#CC6666FF','XROTU_09':'#006699FF','XROTU_37':'#FF9966FF','XROTU_20':'#CC99CCFF','XROTU_27':'#4455BBFF','XROTU_12':'#9977AAFF','XROTU_18':'#9999CCFF','XROTU_25':'#6688CCFF','XROTU_28':'#774466FF','XROTU_15':'#DD6644FF','XROTU_34':'#d3d3d3','XROTU_10':'#d3d3d3','XROTU_16':'#d3d3d3','XROTU_24':'#d3d3d3','XROTU_19':'#d3d3d3','XROTU_21':'#d3d3d3','XROTU_40':'#d3d3d3','XROTU_14':'#d3d3d3','XROTU_36':'#d3d3d3','XROTU_29':'#d3d3d3','XROTU_13':'#d3d3d3','XROTU_32':'#d3d3d3','XROTU_17':'#d3d3d3','XROTU_11':'#d3d3d3','XROTU_23':'#d3d3d3','XROTU_39':'#d3d3d3'};




var g1 = svg.append("g").attr("transform","translate(325,50)");
                         var bp1=viz.bP()
                         .data(data)
                         .value(d=>d[2])
                         .min(10)
                         .pad(1)
                         .height(400)
                         .width(200)
                         .barSize(35)
                         .fill(d=>color[d.secondary])
.sortSecondary(sort(["XROTU_02","XROTU_01","XROTU_04","XROTU_05","XROTU_03","XROTU_06","XROTU_07","XROTU_08","XROTU_09","XROTU_37","XROTU_12","XROTU_20","XROTU_27","XROTU_15","XROTU_18","XROTU_25","XROTU_28","XROTU_10","XROTU_16","XROTU_24","XROTU_14","XROTU_19","XROTU_21","XROTU_29","XROTU_36","XROTU_40","XROTU_11","XROTU_13","XROTU_17","XROTU_32","XROTU_23","XROTU_34","XROTU_39"]))
.orient("vertical");

g1.call(bp1);g1.append("text")
                        .attr("x",-50).attr("y",-8)
                        .style("text-anchor","middle")
                        .text("Dung Beetle");
                        g1.append("text")
                        .attr("x", 250)
                        .attr("y",-8).style("text-anchor","middle")
                        .text("Vertebrate");
                        g1.append("text")
                        .attr("x",100).attr("y",-25)
                        .style("text-anchor","middle")
                        .attr("class","header")
                        .text("Mandai North (Ground)");

 g1.selectAll(".mainBars")
                        .on("mouseover",mouseover)
                        .on("mouseout",mouseout);

 g1.selectAll(".mainBars").append("text").attr("class","label")
                        .attr("x",d=>(d.part=="primary"? -50:29.6))
                        .attr("y",d=>+6)
                        .text(d=>d.key)
                        .attr("text-anchor",d=>(d.part=="primary"? "end": "start"));

 g1.selectAll(".mainBars").append("text").attr("class","perc")
                        .attr("x",d=>(d.part=="primary"? -255:168))
                        .attr("y",d=>+6)
                        .text(function(d){ return d3.format("0.0%")(d.percent)})
                        .attr("text-anchor",d=>(d.part=="primary"? "end": "start")); 

function mouseover(d){
bp1.mouseover(d);
                            g1.selectAll(".mainBars")
                            .select(".perc")
                            .text(function(d){ return d3.format("0.0%")(d.percent)});
}

                     function mouseout(d){
bp1.mouseout(d);
                            g1.selectAll(".mainBars")
                            .select(".perc")
                            .text(function(d){ return d3.format("0.0%")(d.percent)});
}


