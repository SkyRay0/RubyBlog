class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.text :liked_by
      t.string :title
      t.string :category

      t.timestamps
    end
  end
end
