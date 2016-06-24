class MakeTurn < Message
    def initialize
        @uri = URI("#{ENV['CURRENT_CHESS_HOST']}/api/v1/turns.json")
    end

    def post_request(token, game_id, from, to)
        @req = Net::HTTP::Post.new(@uri)
        @req.set_form_data(access_token: token, 'turn[game]' => game_id, 'turn[from]' => from, 'turn[to]' => to)
        self.request
    end
end

    