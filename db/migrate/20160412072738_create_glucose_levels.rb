class CreateGlucoseLevels < ActiveRecord::Migration
  def change
    create_table :glucose_levels do |t|
    	t.integer :glucose_level, null: false
      	t.integer :patient_id, null: false
      	t.timestamps null: false
    end
  end
end
