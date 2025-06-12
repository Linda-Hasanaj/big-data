Chart.defaults.plugins.legend.position = 'bottom'

var data = {
labels:['1912','107','1985','1993','1917','1983','2078','1938','1943','2073',],
datasets : [
{
label: 'Agent (Meta Network)',
backgroundColor: 'rgba(255,0,0,0.2)',
borderColor: 'rgba(255,0,0,1)',
borderWidth: 1,
data : [1,0.826369,0.643299,0.625075,0.607972,0.607283,0.605221,0.603835,0.603045,0.602988,]
},
]
}
var context = document.getElementById('All Measures by CategoryMeta_Network-Agent-overall-top-ranked-barchart').getContext("2d");
var chart = new Chart(context, {
		type: 'bar',
		data: data,
		options: {
			indexAxis:'y',
			autowidth:false,
			scales: {
			yAxes: [{
				ticks: {
					beginAtZero:true
				}
			}]
		}
	}
});

