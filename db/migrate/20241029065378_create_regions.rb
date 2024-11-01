class CreateRegions < ActiveRecord::Migration[6.1]
  def change
    create_table :regions do |t|
      t.text :name

      t.timestamps
    end
  end
end
