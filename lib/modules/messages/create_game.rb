class CreateGame < Message
    def initialize
        @uri = URI("#{ENV['CURRENT_CHESS_HOST']}/api/v1/games.json")
    end

    def post_request(token, challenge_id)
        @req = Net::HTTP::Post.new(@uri)
        @req.set_form_data(access_token: token, 'game[challenge]' => challenge_id)
        self.request
    end
end

    