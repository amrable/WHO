class AddCToIdentities < ActiveRecord::Migration[6.1]
  def change
    add_column :identities, :uuid, :string
  end
end
