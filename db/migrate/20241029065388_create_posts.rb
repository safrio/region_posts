class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.datetime :published_at
      t.references :region, null: false, foreign_key: true

      t.timestamps
    end
  end
end
