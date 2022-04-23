class CreateEndpoints < ActiveRecord::Migration[7.0]
  def change
    create_table :endpoints do |t|
      t.string      :endpoint,     null: false
      t.string      :method,       null: false
      t.string      :content_type, null: false
      t.integer     :status,       default: 200
      t.string      :response_body
      t.integer     :delay,        default: 0
      t.references  :client,       null: false

      t.timestamps
    end
  end
end
