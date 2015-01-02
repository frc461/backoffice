$(function() {
    $('.userimage.waiting').each(function(i) {
        var im = $(this)
        $.get('/uimg', {dn: $(this).data('dn')}, function(data) {
            console.log('Setting DN:' + im.data('dn'));
            im.attr('src', data);
        });
    });
});
