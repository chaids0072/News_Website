class CreateProviders < ActiveRecord::Migration
	def change
		create_table :providers do |t|
			t.string :url
			t.string :source_name
			t.string :source_type

			t.timestamps null: false
		end
	end
end
