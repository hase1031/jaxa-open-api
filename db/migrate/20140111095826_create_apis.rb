class CreateApis < ActiveRecord::Migration
  def change
    create_table :apis do |t|
      t.integer :id
      t.float :lat
      t.float :lon
      t.string :place_name
      t.float :prc
      t.float :sst
      t.float :ssw
      t.float :smc
      t.float :snd
      t.date :date

      t.timestamps
    end
    add_index :apis, :id
  end
end
