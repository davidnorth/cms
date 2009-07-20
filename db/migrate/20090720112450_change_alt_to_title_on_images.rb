class ChangeAltToTitleOnImages < ActiveRecord::Migration
  def self.up
    rename_column "images", "alt", "title"
  end

  def self.down
    rename_column "images", "title", "alt"
  end
end
