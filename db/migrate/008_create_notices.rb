class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.column :title,        :string
      t.column :scope,        :integer
      t.column :user_id,      :integer
      t.column :notice_text,  :text
      t.column :date_posted,  :datetime
      t.column :node_id,      :integer
      t.column :expiry_date,  :datetime
    end
  end

  def self.down
    drop_table :notices
  end
end
