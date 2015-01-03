$(function() {
    $('.userimage.waiting').each(function(i) {
        var im = $(this)
        $.get('/uimg', {dn: $(this).data('dn')}, function(data) {
            im.attr('src', data);
        });
    });
    $('.button.ajax').click(function() {
        var btn = $(this);
        $.get(btn.data('url'), function(data) {
            btn.hide();
            alert('info', data);
        })
    });

});
