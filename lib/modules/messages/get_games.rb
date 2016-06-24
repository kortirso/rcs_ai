class GetGames < Message
    def initialize(token)
        @uri = URI("#{ENV['CURRENT_CHESS_HOST']}/api/v1/games.json?access_token=#{token}")
    end
end