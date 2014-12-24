class MailgunController < ApplicationController
    skip_before_action :verify_authenticity_token
    def receive
        to = params['recipient']
        from = params['from']
        subject = params['subject']
        body = params['body-plain']
        token = params['token']
        timestamp = params['timestamp']
        signature = params['signature']
        if Mailgun.verify(token, timestamp, signature)
            begin
            if u = User.find(:first, from)
                Rails.logger.info("Valid message from #{from}")
                case to
                when /(.+)@boilerinvasion.org/i

                when /(.+)@lists\.boilerinvasion\.org/i
                    Rails.logger.info("Message sent to lists")
                    if $1 =~ /students/i
                            Rails.logger.info("Sending message to students")
                            Mailgun.send(Student.list, to, "[#{g.cn.upcase}] #{subject}", body)
                    elsif $1 =~ /mentors/i
                            Rails.logger.info("Sending message to mentors")
                            Mailgun.send(Mentor.list, to, "[#{g.cn.upcase}] #{subject}", body)
                    elsif $1 =~ /parents/i
                            Rails.logger.info("Sending message to parents")
                            Mailgun.send(Parent.list, to, "[#{g.cn.upcase}] #{subject}", body)
                    elsif $1 =~ /everyone/i
                            Rails.logger.info("Sending message to everyone")
                            Mailgun.send(User.list, to, "[#{g.cn.upcase}] #{subject}", body)
                    else
                        if g = Group.find(:first, $1)
                            Rails.logger.info("Sending message to #{g.cn.upcase}")
                            Mailgun.send(g.list, to, "[#{g.cn.upcase}] #{subject}", body)
                        else
                            Rails.logger.info("Bad group specified: #{$1}")
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
                Rails.logger e.to_s
                File.open(Time.now.to_i.to_s + '.mail.log', 'w') do |f|
                    f << params.to_yaml
                end
                render text: "Exception caught", status: 200
            end
        else
            Rails.logger.error("INVALID MAIL SIGNATURE")
            render text: "Invalid signature!", status: 406
        end
    end
end
