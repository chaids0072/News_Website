class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :link
      t.date :pubDate
      t.string :summary
      t.string :image
      t.string :author
      t.integer :weight
      t.references :provider, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
