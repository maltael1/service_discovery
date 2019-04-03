class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.integer :status
      t.references :reference, polymorphic: true
      t.string :message

      t.timestamps
    end
  end
end
