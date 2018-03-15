var requestId = null;
var cachedLabels = {};

(function() {

	adminBarEnabled = function() {
		return $('#admin-bar').length;
	};

	getRequestId = function() {
		if (requestId != null) {
			return requestId;
		} else {
			return $('#admin-bar').data('request-id');
		}
	}

	updatePerformanceBar = function(results, firstLoad) {
		for (var key in results.data) {
			for (var label in results.data[key]) {
				$("[data-defer-to=" + key + "-" + label + "]")
					.text(results.data[key][label]);

				// Cache results for seamless changes during turbolink navigation
				cachedLabels[key + '_' + label] = { key: key, label: label, data: results.data[key][label] };
			}
		}
	}

	$(document).on('adminbar:render', function(cached) {
		if (cached) {
			for (var key in cachedLabels) {
				var l = cachedLabels[key];
				$("[data-defer-to=" + l.key + "-" + l.label + "]")
					.text(l.data);
			}
		}
	});

	$(document).on('adminbar:update', function(firstLoad) {
		return $.ajax('/admin_bar', {
			data: {
				request_id: getRequestId()
			},
			success: function(data, textStatus, xhr) {
				return updatePerformanceBar(data, firstLoad);
			},
			error: function(xhr, textStatus, error) {}
		});
	});

	$(document).on('turbolinks:render', function() {
		if (!adminBarEnabled()) { return; }

		return $(this).trigger('adminbar:render', true);
	});

	$(document).on('turbolinks:load', function() {
		if (!adminBarEnabled()) { return; }

		return $(this).trigger('adminbar:update', false);
	});

	return $(function() {
		if (!adminBarEnabled()) { return; }

		$(document).trigger('adminbar:update', true);
	});

}())
