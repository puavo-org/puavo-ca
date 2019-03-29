class CreateCertificates < ActiveRecord::Migration[4.2]
  def self.up
    create_table :certificates do |t|
      t.string :fqdn
      t.text :certificate
      t.boolean :revoked, :default => 0
      t.datetime :revoked_at
      t.datetime :valid_until
      t.string :creator
      t.string :revoked_user

      t.timestamps
    end
  end

  def self.down
    drop_table :certificates
  end
end
