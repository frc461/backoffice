function startSpinner() {
    $('#spinner').show();
}

function stopSpinner() {
    $('#spinner').hide();
}

$(document).on("page:fetch", startSpinner);
$(document).on("page:receive", stopSpinner);
