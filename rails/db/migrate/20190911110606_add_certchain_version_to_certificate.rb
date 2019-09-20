class AddCertchainVersionToCertificate < ActiveRecord::Migration[5.2]
  def self.up
    add_column :certificates, :certchain_version, :string
  end

  def self.down
    remove_column :certificates, :certchain_version
  end
end
