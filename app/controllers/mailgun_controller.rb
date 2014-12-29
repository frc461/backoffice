class MailgunController < ApplicationController
    skip_before_action :verify_authenticity_token
    def receive
        to = params['recipient']
        from = params['sender']
        subject = params['subject']
        body = params['body-plain']
        token = params['token']
        timestamp = params['timestamp']
        signature = params['signature']
        if Mailgun.verify(token, timestamp, signature)
            begin
                if u = User.find(from)
                    Rails.logger.info("Valid message from #{from}")
                    case to
                    when /(.+)@boilerinvasion.org/i, /(.+)@a.boilerinvasion.org/i
                        if a = Alias.find(:first, $1)
                        else
                            Rails.logger.info("Bad alias specified: #{$1}")
                            render text: "Bad Alias", status: 200
                        end

                    when /(.+)@lists\.boilerinvasion\.org/i
                        md = to.match(/(.+)@lists\.boilerinvasion\.org/i)
                        Rails.logger.info("Message sent to lists")
                        if md[1] =~ /students/i
                            Rails.logger.info("Sending message to students")
                            Mailgun.send(Student.list - [from], to, "[#{g.cn.upcase}] #{subject}", body, Student.name_list)
                        elsif md[1] =~ /mentors/i
                            Rails.logger.info("Sending message to mentors")
                            Mailgun.send(Mentor.list - [from], to, "[#{g.cn.upcase}] #{subject}", body, Mentor.name_list)
                        elsif md[1] =~ /parents/i
                            Rails.logger.info("Sending message to parents")
                            Mailgun.send(Parent.list - [from], to, "[#{g.cn.upcase}] #{subject}", body, Parent.name_list)
                        elsif md[1] =~ /everyone/i
                            Rails.logger.info("Sending message to everyone")
                            Mailgun.send(User.list - [from], to, "[#{g.cn.upcase}] #{subject}", body, User.name_list)
                        else
                            if g = Group.find(:first, md[1])
                                Rails.logger.info("Sending message to #{g.cn.upcase} for #{md[1]}")
                                Mailgun.send(g.list - [from], to, (subject =~ /^\[/ ? subject : "[#{g.cn.upcase}] #{subject}"), body, g.name_list)
                            else
                                Rails.logger.info("Bad group specified: #{md[1]}")
                                render text: "Bad Group", status: 200
                            end
                        end
                    end
                    render text: "OK", status: 200
                else
                    Rails.logger.error("UNRECOGNIZED SENDER #{from}")
                    render text: "Unrecognized sender", status: 200
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
