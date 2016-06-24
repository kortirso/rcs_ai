class GetGame < Message
    def initialize(token, game_id)
        @uri = URI("#{ENV['CURRENT_CHESS_HOST']}/api/v1/games/#{game_id}.json?access_token=#{token}")
    end
end