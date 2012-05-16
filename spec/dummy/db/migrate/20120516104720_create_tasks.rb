class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.boolean :complete
      t.references :project

      t.timestamps
    end
  end
end
