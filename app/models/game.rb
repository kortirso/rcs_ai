class Game < ActiveRecord::Base
    belongs_to :user
    has_many :figures

    validates :user_id, presence: true

    scope :current, -> { where(game_result: nil) }
    scope :not_get_check, -> { where(checked: false) }
    scope :get_check, -> { where(checked: true) }

    def self.check_games(games_object, user_name, user_id)
        games_object.each { |game_object| Game.check_game(game_object, user_name, user_id) }
        Game.make_complete
        Game.refresh
    end

    def self.check_game(game_object, user_name, user_id)
        game = Game.find_by(server_game_id: game_object['id'])
        if game.nil?
            white_side = game_object['user']['username'] == user_name ? true : false
            game = Game.create server_game_id: game_object['id'], white_turn: game_object['white_turn'], game_result: game_object['game_result'], offer_draw_by: game_object['offer_draw_by'], possibles: [], white_side: white_side, user_id: user_id
        else
            if game.white_turn != game_object['white_turn'] || game.offer_draw_by != game_object['offer_draw_by']
                Game.update white_turn: game_object['white_turn'], game_result: game_object['game_result'], offer_draw_by: game_object['offer_draw_by']
            end
        end
        game.update(checked: true)
        game.make_turn if game.white_turn == game.white_side
    end

    def self.make_complete
        current.not_get_check.each do |game|
            obj = game.user.get_game(game.server_game_id)
            game.update(game_result: obj['game_result']) unless obj['game_result'].nil?
        end
    end

    def self.refresh
        current.get_check.each { |game| game.update(checked: false) }
    end

    def make_turn
        # todo: add making turn algorithm
        from, to = nil, nil
        #self.user.make_turn(self.id, from, to)
    end
end
