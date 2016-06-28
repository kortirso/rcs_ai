class User < ActiveRecord::Base
    has_many :games

    validates :username, :email, :password, :power, presence: true
    validates :username, :email, uniqueness: true

    def get_token
        res = GetToken.new.post_request(self.username, self.password)
        self.update(token: res['access_token']) if res != 'error'
    end

    def get_profile
        res = GetProfile.new(self.token).get_request
        res == 'error' ? self.get_token : self.update(elo: res['elo'])
    end

    def get_challenge_list
        res = GetChallenges.new(self.token).get_request
        res == 'error' ? self.get_token : self.choose_challenge_for_game(res['challenges'])
    end

    def choose_challenge_for_game(challenges)
        for_user = challenges.select { |challenge| !challenge['opponent'].nil? && challenge['opponent']['username'] == self.username }
        for_user.each { |challenge| self.create_game_from_challenge(challenge['id']) }
    end

    def create_game_from_challenge(challenge_id)
        res = CreateGame.new.post_request(self.token, challenge_id)
    end

    def get_games_list
        res = GetGames.new(self.token).get_request
        res == 'error' ? self.get_token : Game.check_games(res['games'], self.username, self.id)
    end

    def get_game(game_id)
        res = GetGame.new(self.token, game_id).get_request
    end

    def make_turn(game_id, from, to)
        res = MakeTurn.new.post_request(self.token, game_id, from, to)
    end

    def self.check_challenges
        all.each { |user| user.get_challenge_list }
    end

    def self.check_games
        all.each { |user| user.get_games_list }
    end
end
