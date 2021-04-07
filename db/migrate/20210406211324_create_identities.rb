class CreateIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :identities do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.string :phone_number
      t.text :additional_info
      t.string :token

      t.timestamps
    end
  end
end
