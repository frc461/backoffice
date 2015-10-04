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

    $('.selector').click(function(){
        $('.hider-data').show();
        $('.hider-type').show();
        console.log(this);
        if($(this).val() == 'my_parent') { $('.type-title').html("Adding your parent"); }
        if($(this).val() == 'parent') { $('.type-title').html("Adding a parent"); }
        if($(this).val() == 'student') { $('.type-title').html("Adding a student"); }
        if($(this).val() == 'mentor') { $('.type-title').html("Adding a mentor"); }
    });

});
