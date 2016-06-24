class AddSideToGame < ActiveRecord::Migration
    def change
        add_column :games, :white_side, :boolean, default: true
    end
end
