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
            game.create_figures
        else
            if game.white_turn != game_object['white_turn'] || game.offer_draw_by != game_object['offer_draw_by']
                game.update white_turn: game_object['white_turn'], game_result: game_object['game_result'], offer_draw_by: game_object['offer_draw_by']
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

    def create_figures
        obj = self.user.get_game(self.server_game_id)
        obj['figures'].each { |figure| self.figures.create server_figure_id: figure['id'], color: figure['color'], type: figure['type'], cell_name: figure['cell_name'], beaten_fields: figure['beaten_fields'] }
    end

    def check_figures(figures)
        figures.each do |figure|
            f = self.figures.find_by(server_figure_id: figure['id'])
            f.update(cell_name: figure['cell_name'], beaten_fields: figure['beaten_fields']) if f.cell_name != figure['cell_name'] || f.beaten_fields != figure['beaten_fields']
        end
    end

    def make_turn
        obj = self.user.get_game(self.server_game_id)
        self.check_figures(obj['figures'])

        result, from, to = [], nil, nil
        if obj['possibles'] == []
            color_side = self.white_side ? 'white' : 'black'
            figures = self.figures.on_the_board.current_color(color_side)
            figures.to_ary.each { |figure| result.push(figure) unless figure.beaten_fields == [] }
            rand_figure = result.sample
            fields = rand_figure.beaten_fields
            if rand_figure.type == 'p'
                fields.delete_if { |cell| self.figures.on_the_board.other_color(color_side).find_by(cell_name: cell).nil? }
                p_cell = rand_figure.cell_name
                mod = color_side == 'white' ? 1 : -1
                if figures.find_by(cell_name: "#{p_cell[0]}#{p_cell[1].to_i + mod}").nil?
                    fields.push("#{p_cell[0]}#{p_cell[1].to_i + mod}")
                    if figures.find_by(cell_name: "#{p_cell[0]}#{p_cell[1].to_i + mod * 2}").nil? && (rand_figure.color == 'white' && p_cell[1] == '2' || rand_figure.color == 'black' && p_cell[1] == '7')
                        fields.push("#{p_cell[0]}#{p_cell[1].to_i + mod * 2}", "#{p_cell[0]}#{p_cell[1].to_i + mod * 2}")
                    end
                end
            end
            rand_turn = fields.sample
            from, to = rand_figure.cell_name, rand_turn
        else
            turn = obj['possibles'].sample
            from, to = turn[0], turn[1]
        end
        self.user.make_turn(self.server_game_id, from, to)
    end
end
