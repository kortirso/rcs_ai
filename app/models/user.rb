require 'net/http'

class User < ActiveRecord::Base
    validates :username, :email, :password, :power, presence: true
    validates :username, :email, uniqueness: true

    def get_token
        uri = URI(ENV['CURRENT_CHESS_HOST'] + '/oauth/token')
        req = Net::HTTP::Post.new(uri)
        req.set_form_data(grant_type: 'password', username: self.username, password: self.password)

        res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
        if res.code == '200'
            obj = JSON.parse(res.body)
            self.update(token: obj['access_token'])
        end
    end

    def get_profile
        uri = URI(ENV['CURRENT_CHESS_HOST'] + "/api/v1/profiles/me.json?access_token=#{self.token}")
        req = Net::HTTP::Get.new(uri)

        res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
        if res.code == '200'
            obj = JSON.parse(res.body)
            self.update(elo: obj['user']['elo'])
        end
    end
end
