class AddWebhooks < ActiveRecord::Migration[7.1]
  def change
    create_table :inbound_webhooks do |t|
      t.integer :status, default: 'pending', null: false
      t.text :body

      t.timestamps
    end
  end
end
