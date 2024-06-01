class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.string :name
      t.string :url
      t.boolean :is_healthy

      t.timestamps
    end
  end
end
