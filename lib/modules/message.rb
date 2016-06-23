require 'net/http'

class Message
    def get_request
        @req = Net::HTTP::Get.new(@uri)
        self.request
    end

    def request
        res = Net::HTTP.start(@uri.hostname, @uri.port) { |http| http.request(@req) }
        result = res.code == '200' ? JSON.parse(res.body) : 'error'
    end
end