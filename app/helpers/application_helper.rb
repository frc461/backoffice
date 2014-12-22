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
end
