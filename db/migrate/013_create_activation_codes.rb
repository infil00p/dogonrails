class CreateActivationCodes < ActiveRecord::Migration
  def self.up
    create_table :activation_codes do |t|
      t.column :user_id,  :integer
      t.column :activation_code, :string
    end
  end

  def self.down
    drop_table :activation_codes
  end
end
