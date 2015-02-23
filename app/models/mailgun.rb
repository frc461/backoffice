require 'openssl'

class Mailgun
    class << self
        def verify(token, timestamp, signature)
            digest = OpenSSL::Digest::SHA256.new
            data = [timestamp, token].join
            signature == OpenSSL::HMAC.hexdigest(digest,Rails.application.secrets.mailgun_api_key , data)
        end

        def send to, from, subject, text, vars=nil, reply=nil, attachments=nil
            RestClient.post 'https://api:key-3b54b4da075069b7750c8d79a5d4ca15@api.mailgun.net/v2/sandbox935faa4fe652499b942c660a43411ad9.mailgun.org/messages', 
                :from => from,
                :to => to,
                :subject => subject,
                :text => text,
                :"h:Reply-To" => reply,
                :'recipient-variables' => vars.to_json,
                :attachment => attachments
        end

        def send_to_group group, from, subject, text, vars=nil
            group.list.each do |m|
            RestClient.post 'https://api:key-3b54b4da075069b7750c8d79a5d4ca15@api.mailgun.net/v2/sandbox935faa4fe652499b942c660a43411ad9.mailgun.org/messages', 
                :from => from,
                :to => to,
                :"h:Reply-To" => "#{group.cn}@lists.boilerinvasion.org",
                :subject => subject,
                :text => text
            end
        end
    end
end
