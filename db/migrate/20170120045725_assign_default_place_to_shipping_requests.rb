class AssignDefaultPlaceToShippingRequests < ActiveRecord::Migration
  def up
    say_with_time "making all shipping requests belong to first place" do
      if Place.first
        place_id = Place.first.id
        ShippingRequest.find_each do |shipping_request|
          shipping_request.update!(place_id: place_id)
        end
      end
    end

    change_column :shipping_requests, :place_id, :integer, null: false
  end
end
