class AddRegionToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :region
  end
end
