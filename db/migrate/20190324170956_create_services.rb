class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.references :service_variant, foreign_key: true
      t.integer :status
      t.string :host
      t.string :token
      t.string :gate_host

      t.timestamps
    end
  end
end
