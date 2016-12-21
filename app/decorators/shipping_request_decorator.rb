class ShippingRequestDecorator < GenericResourceDecorator
  delegate_all
  decorates_association :resource

  def to_s
    title
  end

  def link_to_resource(options=nil, &block)
    h.link_to(
      h.admin_shipping_request_path(object.id),
      options,
      &block
    )
  end

  def card_attributes
    [
      :created_at,
      :address,
      :provider,
      :telefono
    ]
  end

  def title
    I18n.t("admin.shipping_request.title") + " ##{object.id}"
  end

  def created_at
    I18n.l(object.created_at, format: :admin_full)
  end

  def address
    address_attributes["direccion"] if address_attributes.present?
  end

  def provider
    resource.nombre_establecimiento
  end

  def telefono
    address_attributes["telefono"] if address_attributes.present?
  end

  def kind_str
    I18n.t("shipping_request.kinds.#{kind}")
  end
end
