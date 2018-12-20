class AddForeignKeys < ActiveRecord::Migration[5.2]
  def change
    add_reference :bills, :billing, foreign_key: true
    add_reference :payments, :bill, foreign_key: true
  end
end
