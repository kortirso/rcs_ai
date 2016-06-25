class AddStillToGames < ActiveRecord::Migration
    def change
        add_column :games, :checked, :boolean, default: false
    end
end
