require 'net/http'

class User < ActiveRecord::Base
    validates :username, :email, :password, :power, presence: true
    validates :username, :email, uniqueness: true

    MAX_GAMES = 10

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
        elsif res.code == '401'
            self.get_token
        end
    end

    def get_challenge_list
        uri = URI(ENV['CURRENT_CHESS_HOST'] + "/api/v1/challenges.json?access_token=#{self.token}")
        req = Net::HTTP::Get.new(uri)

        res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }

        if res.code == '200'
            obj = JSON.parse(res.body)
            self.choose_challenge_for_game(obj['challenges'])
        elsif res.code == '401'
            self.get_token
            self.get_challenge_list
        end
    end

    def choose_challenge_for_game(challenges)
        for_user = challenges.select { |challenge| !challenge['opponent'].nil? && challenge['opponent']['username'] == self.username }
        for_user.each { |challenge| self.create_game_from_challenge(challenge['id']) }
    end

    def create_game_from_challenge(challenge_id)
        uri = URI(ENV['CURRENT_CHESS_HOST'] + '/api/v1/games.json')
        req = Net::HTTP::Post.new(uri)
        req.set_form_data(access_token: self.token, 'game[challenge]' => challenge_id)

        res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }

        if res.code == '401'
            self.get_token
            self.create_game_from_challenge(challenge_id)
        end
    end

    def self.check_challenges
        all.each { |user| user.get_challenge_list }
    end
end
