class MailgunController < ApplicationController
    skip_before_action :verify_authenticity_token
    def receive
        recipient = params['recipient']
        from = params['sender']
        subject = params['subject']
        body = params['body-html'] || params['body-plain'] || "."
        token = params['token']
        timestamp = params['timestamp']
        signature = params['signature']
        attachment = []
        0.upto(params['attachment-count'].to_i) do |i|
            attachment << params["attachment-#{i}"]
        end
        if Mailgun.verify(token, timestamp, signature)
            begin
                    Rails.logger.info("Valid message from #{from}")
                    case recipient
                    when /(.+)@boilerinvasion.org/i, /(.+)@a.boilerinvasion.org/i
                        if a = Alias.find(:first, $1)
                            to = User.find([a.roleOccupant].flatten.first).mail
                            Rails.logger.info("Sending message to alias #{a.cn} => #{to}")
                            Mailgun.send(to, from, subject, body, nil, nil, attachment)
                            render text: "OK", status: 200
                        else
                            Rails.logger.info("Bad alias specified: #{$1}")
                            render text: "Bad Alias", status: 200
                        end

                    when /(.+)@lists\.boilerinvasion\.org/i
                        if u = User.find(from)
                            md = recipient.match(/(.+)@lists\.boilerinvasion\.org/i)
                            Rails.logger.info("Message sent to lists")
                            if md[1] =~ /students/i
                                Rails.logger.info("Sending message to students")
                                Mailgun.send(Student.list, recipient, "[WBI STUDENTS] #{subject}", body, Student.name_list, from, attachment)
                                render text: "OK", status: 200
                            elsif md[1] =~ /mentors/i
                                Rails.logger.info("Sending message to mentors")
                                Mailgun.send(Mentor.list, recipient, "[WBI MENTORS] #{subject}", body, Mentor.name_list, recipient, attachment)
                                render text: "OK", status: 200
                            elsif md[1] =~ /parents/i
                                Rails.logger.info("Sending message to parents")
                                Mailgun.send(Parent.list, recipient, "[WBI PARENTS] #{subject}", body, Parent.name_list, from, attachment)
                                render text: "OK", status: 200
                            elsif md[1] =~ /everyone/i
                                Rails.logger.info("Sending message to everyone")
                                Mailgun.send(User.list, recipient, "[WBI] #{subject}", body, User.name_list, from, attachment)
                                render text: "OK", status: 200
                            elsif md[1] =~ /meeting-\d+/i
                                m = Meeting.find(md[1].match(/meeting-(\d+)/)[1])
                                if m
                                    Rails.logger.info("Sending message to #{m.name} attendees")
                                    Mailgun.send(m.list, recipient, "[WBI #{m.name.upcase}] #{subject}", body, m.name_list, from, attachment)
                                end

                            else
                                if g = Group.find(:first, md[1])
                                    Rails.logger.info("Sending message to #{g.cn.upcase} for #{md[1]}")
                                    Mailgun.send(g.list, recipient, (subject =~ /^\[/ ? subject : "[#{g.cn.upcase}] #{subject}"), body, g.name_list, recipient, attachment)
                                    render text: "OK", status: 200
                                else
                                Rails.logger.info("Bad group specified: #{md[1]}")
                                    render text: "Bad Group", status: 200
                                end
                            end
                        end
                    end
            rescue => e
                Rails.logger.error "EXCEPTION!!"
                Rails.logger.error e.inspect
                File.open(Time.now.to_i.to_s + '.mail.log', 'w') do |f|
                    f << params.to_yaml
                    f << ('=' * 30) + "\n"
                    f << e.inspect
                    f << ('-' * 30) + "\n"
                    f << e.backtrace.join("\n")
                end
                render text: "Exception caught", status: 200
            end
        else
            Rails.logger.error("INVALID MAIL SIGNATURE")
            render text: "Invalid signature!", status: 406
        end
    end
end
