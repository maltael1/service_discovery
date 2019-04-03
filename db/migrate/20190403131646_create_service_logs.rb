class CreateServiceLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :service_logs do |t|
      t.integer :status
      t.references :service, foreign_key: true
      t.string :message

      t.timestamps
    end
  end
end
