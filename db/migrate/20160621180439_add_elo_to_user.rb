class AddEloToUser < ActiveRecord::Migration
    def change
        add_column :users, :elo, :integer, default: 0
    end
end
