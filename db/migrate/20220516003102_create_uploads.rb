class CreateUploads < ActiveRecord::Migration[7.0]
  def change
    create_table :uploads do |t|
      t.string :filename
      t.string :url_hash
      t.string :endpoint

      t.timestamps
    end
  end
end
