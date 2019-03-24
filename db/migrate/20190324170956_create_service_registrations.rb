class CreateServiceRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :service_registrations do |t|
      t.references :service, foreign_key: true
      t.integer :status_cd
      t.string :host
      t.string :code

      t.timestamps
    end
  end
end
