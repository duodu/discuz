class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :content
      t.integer :flag_id
      t.integer :user_id
      t.integer :top_id

      t.timestamps
    end
  end
end
