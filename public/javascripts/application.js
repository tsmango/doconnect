function hideErrorMessage() {
	if($('flash') && $('flash').style.display != 'none') {
		Effect.SlideUp('flash', { duration: 0.25 });
	}
}

function remove_fields(link) {
  $j(link).prev("input[type=hidden]").val("1");
  $j(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $j(link).parent().before(content.replace(regexp, new_id));
}