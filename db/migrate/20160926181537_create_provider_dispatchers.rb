class CreateProviderDispatchers < ActiveRecord::Migration
  def change
    create_table :provider_dispatchers do |t|
      t.references :provider_profile, null: false, index: true, foreign_key: true
      t.references :provider_office, null: false, index: true, foreign_key: true
      t.string :email

      t.timestamps null: false
    end
  end
end
