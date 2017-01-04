class GenericResourceDecorator < Draper::Decorator
  delegate_all

  def label_for(attribute)
    klass_name = object.class.to_s.underscore
    h.t(
      "activerecord.attributes.#{klass_name}.#{attribute}"
    ) + ":"
  end

  def hidden_attr_for_history?(key)
    @hidden_attrs ||= [
      :created_at,
      :updated_at
    ].freeze
    @hidden_attrs.include?(key.to_sym)
  end

  def link_to_resource(options=nil, &block)
    h.content_tag :span, options, &block
  end

  def str_with_link
    link_to_resource { to_s }
  end
end
