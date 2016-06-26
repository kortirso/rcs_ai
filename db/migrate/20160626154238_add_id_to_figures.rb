class AddIdToFigures < ActiveRecord::Migration
    def change
        add_column :figures, :server_figure_id, :integer
    end
end
