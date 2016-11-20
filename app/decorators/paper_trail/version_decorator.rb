module PaperTrail
  class VersionDecorator < Draper::Decorator
    delegate_all

    def decorated_associations
      associations.map do |association|
        klass = "::" + association.item_type + "Decorator"
        klass.constantize.new(association.item)
      end
    end

    def link_to_whodunnit(&block)
      if whodunnit.present?
        h.link_to(whodunnit_path, &block)
      else
        h.content_tag(:span, &block)
      end
    end

    def whodunnit_imagen_url
      if whodunnit.present?
        whodunnit.image_url
      else
        default_email = "hola@moviggo.com"
        h.gravatar_image_url(default_email)
      end
    end

    def whodunnit_link_with_name
      if whodunnit.present?
        h.link_to whodunnit.to_s, whodunnit_path
      else
        h.t("admin.history.not_user")
      end
    end

    def action
      model_key = object.item_type.underscore
      h.t("admin.#{model_key}.history.#{event}")
    end

    def created_at
      h.l(object.created_at, format: :admin_full)
    end

    private

    def associations
      object.class.where(
        transaction_id: transaction_id
      ).where.not(item_type: object.item_type)
    end

    def whodunnit_path
      h.admin_user_path(whodunnit)
    end

    def whodunnit
      return if object.whodunnit.blank?
      @whodunnit ||= User.find(object.whodunnit).decorate
    end
  end
end
