class MailgunController < ApplicationController
    skip_before_action :verify_authenticity_token
    def receive
        to = params['recipient']
        from = params['sender']
        subject = params['subject']
        body = params['body-html']
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
                    case to
                    when /(.+)@boilerinvasion.org/i, /(.+)@a.boilerinvasion.org/i
                        if a = Alias.find(:first, $1)
                            to = User.find([a.roleOccupant].flatten.first).mail
                            Rails.logger.info("Sending message to alias #{a.cn} => #{to}")
                            Mailgun.send(to, from, subject, body, nil, nil, attachment)
                        else
                            Rails.logger.info("Bad alias specified: #{$1}")
                            render text: "Bad Alias", status: 200
                        end

                    when /(.+)@lists\.boilerinvasion\.org/i
                        if u = User.find(from)
                            md = to.match(/(.+)@lists\.boilerinvasion\.org/i)
                            Rails.logger.info("Message sent to lists")
                            if md[1] =~ /students/i
                                Rails.logger.info("Sending message to students")
                                Mailgun.send(Student.list, from, "[WBI STUDENTS] #{subject}", body, Student.name_list, to, attachment)
                            elsif md[1] =~ /mentors/i
                                Rails.logger.info("Sending message to mentors")
                                Mailgun.send(Mentor.list, from, "[WBI MENTORS] #{subject}", body, Mentor.name_list, to, attachment)
                            elsif md[1] =~ /parents/i
                                Rails.logger.info("Sending message to parents")
                                Mailgun.send(Parent.list, from, "[WBI PARENTS] #{subject}", body, Parent.name_list, to, attachment)
                            elsif md[1] =~ /everyone/i
                                Rails.logger.info("Sending message to everyone")
                                Mailgun.send(User.list, from, "[WBI] #{subject}", body, User.name_list, nil, attachment)
                            else
                                if g = Group.find(:first, md[1])
                                    Rails.logger.info("Sending message to #{g.cn.upcase} for #{md[1]}")
                                    Mailgun.send(g.list, from, (subject =~ /^\[/ ? subject : "[#{g.cn.upcase}] #{subject}"), body, g.name_list, to, attachment)
                                else
                                Rails.logger.info("Bad group specified: #{md[1]}")
                                    render text: "Bad Group", status: 200
                                end
                            end
                        end
                    end
                    render text: "OK", status: 200
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
