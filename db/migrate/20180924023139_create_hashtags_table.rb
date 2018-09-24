class CreateHashtagsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtags do |table|
      table.text :tag
      table.references :post
      table.timestamps 
    end
  end
end
