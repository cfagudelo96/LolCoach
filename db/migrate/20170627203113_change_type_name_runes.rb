class ChangeTypeNameRunes < ActiveRecord::Migration[5.1]
  def change
    rename_column :runes, :type, :color
  end
end
