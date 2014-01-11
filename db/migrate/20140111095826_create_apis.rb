class CreateApis < ActiveRecord::Migration
  def change
    create_table :apis do |t|
      t.float :lat,:null=>false,:scale=>1,:precision=>3
      t.float :lon,:null=>false,:scale=>1,:precision=>4
      t.string :place_name,:null=>true,:limit=>32
      t.float :prc,:null=>true,:scale=>1,:precision=>5
      t.float :sst,:null=>true,:scale=>1,:precision=>5
      t.float :ssw,:null=>true,:scale=>1,:precision=>5
      t.float :smc,:null=>true,:scale=>1,:precision=>5
      t.float :snd,:null=>true,:scale=>1,:precision=>5
      t.date :date,:null=>false
    end
    add_index :apis, [:lat, :lon]
  end
end
