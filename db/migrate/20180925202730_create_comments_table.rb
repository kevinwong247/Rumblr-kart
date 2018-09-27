class CreateCommentsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |table|
      table.text :commentary
      table.references :user
      table.references :post
      table.timestamps 
    end
  end 
end
