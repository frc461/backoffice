require 'kramdown'

module ApplicationHelper
    def foundation_flash
        flash_messages = []
        flash.each do |type, message|
            next if message.blank?
            if type = :notice
                type = :success
            elsif type = :alert
                type = :alert
            elsif type = :error
                type = alert
            else
                type = :info
            end
            Array(message).each do |msg|
                text = content_tag(:li, content_tag(:a, content_tag(:div,
                                                                    msg.html_safe, :class => "alert-box #{type}")))
                flash_messages << text if msg
            end
        end
        flash_messages.join("\n").html_safe
    end

    def user_photo u
        if u.jpegPhoto
            image_tag 'generic.png', class: 'userimage waiting', data: {:dn => u.dn.to_s}
        else
            image_tag 'generic.png', class: 'userimage'
        end 
    end

    def kr text
        Kramdown::Document.new(text).to_html.html_safe
    end

    def student_status_name(student)
        if student.me.is_a? Student
        str = ''
        if student.graduated? 
            str << '<span style="color: #22b">' + fa_icon('graduation-cap') + ' '
        end 
        if student.recruit?
            str << '<span style="color: #2b3">' + fa_icon('plus-circle') + ' '
        end 
        if student.dropped?
            str << '<span style="color: #c00">' + fa_icon('exclamation-triangle') + ' '
        end
        if student.orphan?
            str << fa_stacked_icon('group', base: 'ban') + ' '
        end
        str << student.cn
        if student.graduated? || student.dropped? || student.recruit?
            str << '</span>'
        end
        str.html_safe
        else
            student.cn
        end
    end
end
