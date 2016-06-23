class GetToken < Message
    def initialize
        @uri = URI("#{ENV['CURRENT_CHESS_HOST']}/oauth/token")
    end

    def post_request(username, password)
        @req = Net::HTTP::Post.new(@uri)
        @req.set_form_data(grant_type: 'password', username: username, password: password)
        self.request
    end
end

    