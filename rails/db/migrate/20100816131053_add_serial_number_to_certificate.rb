class AddSerialNumberToCertificate < ActiveRecord::Migration
  def self.up
    add_column :certificates, :serial_number, :integer
  end

  def self.down
    remove_column :certificates, :serial_number
  end
end
