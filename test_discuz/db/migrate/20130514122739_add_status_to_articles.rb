class AddStatusToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :submit_date, :datetime
    add_column :articles, :last_edit_date, :datetime
  end
end
