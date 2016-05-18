class CreatePaymentItems < ActiveRecord::Migration
  def change
    create_table :payment_items do |t|
      t.decimal :amount
      t.belongs_to :payment, index: true
      t.belongs_to :event, index: true
    end
  end
end