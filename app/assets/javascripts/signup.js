$(document).on('page:change', function() {
	
	$('#player_first_name').on('input propertychange paste', function() {
		if($('#player_first_name').val().trim().length == 0) {
			$('#player_first_name').attr("Class", "text_box input_error");
		}
		else {
			$('#player_first_name').attr("class", "text_box input_ok");
		}
		
	});
	
	$('#player_last_name').on('input propertychange paste', function() {
		if($('#player_last_name').val().trim().length == 0) {
			$('#player_last_name').attr("Class", "text_box input_error");
		}
		else {
			$('#player_last_name').attr("class", "text_box input_ok");
		}
		
	});
	
	$('#player_email').on('input propertychange paste', function() {
		var pattern = /@([\w-]+\.)/;
		var emailstring = $('#player_email').val();
		if(pattern.test(emailstring)) {
			$.ajax({
				type: "POST",
				url: "/check-email",
				data: { email: $('#player_email').val().toLowerCase()},
				dataType: "json",
				success: function(data) {
					if(data == "true") {
						$('#player_email').attr("Class", "text_box input_error");
					}
					else {
						$('#player_email').attr("Class", "text_box input_ok");
					}
				}
			});
		}
		else {
			$('#player_email').attr("Class", "text_box input_error");
		}
			
	});
		
	$('#player_password').on('input propertychange paste', function() {
		if($('#player_password').val().length < 8) {
			$('#player_password').attr("Class", "text_box input_error");
		}
		else {
			$('#player_password').attr("class", "text_box input_ok");
		}
		
	});
	
	$('#player_screen_name').on('input propertychange paste', function() {
		$.ajax({
			type: "POST",
			url: "/check-screen",
			data: { screen_name: $('#player_screen_name').val()},
			dataType: "json",
			success: function(data) {
				if(data == "true") {
					$('#player_screen_name').attr("Class", "text_box input_error");
				}
				else {
					$('#player_screen_name').attr("Class", "text_box input_ok");
				}
			}
		});
			
	});
	
});
