class GetProfile < Message
    def initialize(token)
        @uri = URI("#{ENV['CURRENT_CHESS_HOST']}/api/v1/profiles/me.json?access_token=#{token}")
    end
end