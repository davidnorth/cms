class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.timestamps
      t.references :page, :attachable
      t.integer :position
      t.string :attachable_type, :container, :size
    end
  end

  def self.down
    drop_table :attachments
  end
end
