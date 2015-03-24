class CreateSitemaps < ActiveRecord::Migration
  def change
    create_table :sitemaps do |t|
      t.string :url
      t.text :xml

      t.timestamps
    end
  end
end
