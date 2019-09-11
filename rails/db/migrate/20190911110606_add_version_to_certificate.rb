class AddVersionToCertificate < ActiveRecord::Migration[5.2]
  def self.up
    add_column :certificates, :version, :string
  end

  def self.down
    remove_column :certificates, :version
  end
end
