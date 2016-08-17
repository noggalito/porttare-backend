if @errors.present?
  json.errors do
    @errors.to_hash.each do |key, value|
      json.set! key, value
    end
  end
end
