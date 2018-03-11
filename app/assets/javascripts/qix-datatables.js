$(document).ready(function() {
    $('#puglist').DataTable( {
						"columnDefs": [
					{ "orderable": false, "targets": 4 },
					{ "orderable": false, "targets": 5 }
				  ],
				"paging":   false,
				"ordering": true,
				"searching": false,
				"info":     false
			} );
			
	
} );