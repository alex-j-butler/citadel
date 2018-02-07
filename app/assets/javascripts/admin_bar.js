var requestId = null;

(function() {

	adminBarEnabled = function() {
		return $('#peek').length;
	};

	getRequestId = function() {
		if (requestId != null) {
			return requestId;
		} else {
			return $('#admin-bar').data('request-id');
		}
	}

	updatePerformanceBar = function(results) {
		$("#admin-bar > .container")
			.animate({ opacity: 1 }, 50);

		for (var key in results.data) {
			for (var label in results.data[key]) {
				// $("[data-defer-to=" + key + "-" + label + "]").text(results.data[key][label]);


				$("[data-defer-to=" + key + "-" + label + "]")
					.text(results.data[key][label]);
			}
		}
	}

	$(document).on('adminbar:preupdate', function() {
		$("#admin-bar > .container")
			.animate({ opacity: 0 }, 50);
	});

	$(document).on('adminbar:update', function() {
		return $.ajax('/admin_bar', {
			data: {
				request_id: getRequestId()
			},
			success: function(data, textStatus, xhr) {
				return updatePerformanceBar(data);
			},
			error: function(xhr, textStatus, error) {}
		});
	});

	$(document).on('page:change turbolinks:load', function() {
		if (!adminBarEnabled()) { return; }

		return $(this).trigger('adminbar:update');
	});

	$(document).on('turbolinks:visit', function() {
		if (!adminBarEnabled()) { return; }

		return $(this).trigger('adminbar:preupdate')
	});

	return $(function() {
		if (!adminBarEnabled()) { return; }
		
		$(document).trigger('adminbar:update');
	});

}())
