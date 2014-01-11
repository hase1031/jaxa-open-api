class CreateApis < ActiveRecord::Migration
  def change
    create_table :apis do |t|
      t.integer :lat,:null=>false
      t.integer :lon,:null=>false
      t.string :place_name,:null=>true,:limit=>32
      t.integer :prc,:null=>true
      t.integer :sst,:null=>true
      t.integer :ssw,:null=>true
      t.integer :smc,:null=>true
      t.integer :snd,:null=>true
      t.date :date,:null=>false
    end
    add_index :apis, [:lat, :lon]
  end
end
