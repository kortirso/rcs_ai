class CreateGames < ActiveRecord::Migration
    def change
        create_table :games do |t|
            t.integer :server_game_id
            t.boolean :white_turn, default: true
            t.float :game_result, default: nil
            t.integer :offer_draw_by, default: nil
            t.string :possibles, default: [], array: true
            t.timestamps null: false
        end
    end
end
