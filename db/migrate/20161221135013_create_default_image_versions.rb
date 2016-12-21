class CreateDefaultImageVersions < ActiveRecord::Migration
  def up
    say_with_time "creating default image versions" do
      ProviderProfile.find_each do |provider_profile|
        if provider_profile.logotipo?
          provider_profile.logotipo.recreate_versions!
        end
      end
      ProviderItem.find_each do |provider_item|
        provider_item.imagenes.each do |imagen|
          imagen.imagen.recreate_versions!
        end
      end
      User.find_each do |user|
        if user.custom_image?
          user.custom_image.recreate_versions!
        end
      end
    end
  end

  def down
    say "doing nothing"
  end
end
