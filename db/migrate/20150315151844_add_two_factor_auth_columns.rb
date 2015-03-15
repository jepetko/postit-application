class AddTwoFactorAuthColumns < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :pin, :integer
  end
end
