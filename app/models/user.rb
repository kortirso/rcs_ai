require 'net/http'

class User < ActiveRecord::Base
    has_many :games

    validates :username, :email, :password, :power, presence: true
    validates :username, :email, uniqueness: true

    MAX_GAMES = 10

    def get_token
        object = GetToken.new
        res = object.post_request(self.username, self.password)
        self.update(token: res['access_token']) if res != 'error'
    end

    def get_profile
        object = GetProfile.new(self.token)
        res = object.get_request
        res == 'error' ? self.get_token : self.update(elo: res['user']['elo'])
    end

    def get_challenge_list
        object = GetChallenges.new(self.token)
        res = object.get_request
        res == 'error' ? self.get_token : self.choose_challenge_for_game(res['challenges'])
    end

    def choose_challenge_for_game(challenges)
        for_user = challenges.select { |challenge| !challenge['opponent'].nil? && challenge['opponent']['username'] == self.username }
        for_user.each { |challenge| self.create_game_from_challenge(challenge['id']) }
    end

    def create_game_from_challenge(challenge_id)
        object = CreateGame.new
        res = object.post_request(self.token, challenge_id)
    end

    def get_games_list
        object = GetGames.new(self.token)
        res = object.get_request
        if res == 'error'
            self.get_token
        else
            res['games'].each { |game| Game.check_game(game) }
        end
    end

    def get_game(game_id)
        object = GetGame.new(self.token, game_id)
        res = object.get_request
    end

    def make_turn
        object = MakeTurn.new
        res = object.post_request(self.token, game_id, from, to)
    end

    def self.check_challenges
        all.each { |user| user.get_challenge_list }
    end
end
