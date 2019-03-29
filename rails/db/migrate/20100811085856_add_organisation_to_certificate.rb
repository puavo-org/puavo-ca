class AddOrganisationToCertificate < ActiveRecord::Migration[4.2]
  def self.up
    add_column :certificates, :organisation, :string
  end

  def self.down
    remove_column :certificates, :organisation
  end
end
