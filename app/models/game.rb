class Game < ActiveRecord::Base
    belongs_to :user
    has_many :figures

    validates :user_id, presence: true

    def username
        self.user.username
    end

    def self.check_game(game_object)
        game = find_by(server_game_id: game_object['id'])
        if game.nil?
            white_side = game['user']['username'] == game.username ? true : false
            Game.create server_game_id: game_object['id'], white_turn: game_object['white_turn'], game_result: game_object['game_result'], offer_draw_by: game_object['offer_draw_by'], possibles: [], white_side: white_side
        else
            if game.white_turn != game_object['white_turn'] || game.game_result != game_object['game_result'] || game.offer_draw_by != game_object['offer_draw_by']
                Game.update white_turn: game_object['white_turn'], game_result: game_object['game_result'], offer_draw_by: game_object['offer_draw_by']
            end
        end
    end
end
