var TunnelModel = function(tunnels) {
    var self = this;
    self.tunnels = ko.observableArray(tunnels);

    self.addTunnel = function() {
        self.tunnels.push({
            name: "",
            peer_id: "",
			peer_ip: "",
			local_id: "",
			local_ip: "",
			shared_secret: "",
			local_networks: "",
			peer_networks: ""
        });
    };
 
    self.removeTunnel = function(tunnel) {
        self.tunnels.remove(tunnel);
    };
 
    self.save = function(form) {
        alert("Could now transmit to server: " + ko.utils.stringifyJson(self.tunnels));
        // To actually transmit to server as a regular form post, write this: ko.utils.postJson($("form")[0], self.gifts);
    };
	
	self.quantity = self.tunnels.length
	
	self.viewModel = new ko.simpleGrid.viewModel({
        data: self.tunnels,
        columns: [
            { headerText: "name: ", rowText: "name" },
			{ headerText: "peer_id", rowText: "peer_id" },
			{ headerText: "peer_ip", rowText: "peer_ip" },
			{ headerText: "local_id", rowText: "local_id" },
			{ headerText: "local_ip", rowText: "local_ip" },
			{ headerText: "shared_secret", rowText: "shared_secret" },
			{ headerText: "local_networks", rowText: "local_networks" },
			{ headerText: "peer_networks", rowText: "peer_networks" }
            
            
        ],
        pageSize: 14
    });
};
 


$.getJSON("/api/tunnel_info", function(adminData) { 
    // Now use this data to update your view models, 
    // and Knockout will update your UI automatically 
	var viewModel = new TunnelModel(adminData);
	ko.applyBindings(viewModel);
	
});



 

