class CreateFigures < ActiveRecord::Migration
    def change
        create_table :figures do |t|
            t.integer :game_id
            t.string :color
            t.string :type
            t.string :cell_name
            t.string :beaten_fields, default: [], array: true
            t.timestamps null: false
        end

        add_index :figures, :game_id
    end
end
