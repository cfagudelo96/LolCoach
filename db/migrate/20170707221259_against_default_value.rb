class AgainstDefaultValue < ActiveRecord::Migration[5.1]
  def change
    change_column :tips, :against, :boolean, default: false
  end
end
