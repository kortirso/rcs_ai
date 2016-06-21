class AddTokenToUser < ActiveRecord::Migration
    def change
        add_column :users, :token, :string, default: ''
    end
end
