class CreateLinkedins < ActiveRecord::Migration
  def change
    create_table :linkedins do |t|

      t.timestamps
    end
  end
end
