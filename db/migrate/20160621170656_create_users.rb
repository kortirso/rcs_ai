class CreateUsers < ActiveRecord::Migration
    def change
        create_table :users do |t|
            t.string :username, dafault: ''
            t.string :email, default: ''
            t.string :password, default: ''
            t.integer :power, default: 1
            t.timestamps null: false
        end
    end
end
