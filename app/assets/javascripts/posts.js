$(document).ready(function() {
	$('#playlist_id').live('change', function() {
		alert("fsdfs");
		/*
		$.ajax({
			url: "posts/set_current_playlist",
			type: "GET",
			data: {select_tag_value: $('#playlist_id option:selected').value()}; 
		})
		*/
	});
});
