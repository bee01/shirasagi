# coding: utf-8
class Cms::Part
  extend ActiveSupport::Autoload
  autoload :Model

  include Cms::Part::Model

  index({ site_id: 1, filename: 1 }, { unique: true })

  class Base
    include Cms::Part::Model

    default_scope ->{ where(route: /^cms\//) }
  end

  class Free
    include Cms::Part::Model
    include Cms::Addon::Html

    default_scope ->{ where(route: "cms/free") }

    def render_html
      SS.config.cms.ajax_free_part ? super : html
    end
  end

  class Node
    include Cms::Part::Model
    include Cms::Addon::NodeList

    default_scope ->{ where(route: "cms/node") }
  end

  class Page
    include Cms::Part::Model
    include Cms::Addon::PageList

    default_scope ->{ where(route: "cms/page") }
  end

  class Tabs
    include Cms::Part::Model
    include Cms::Addon::Tabs

    default_scope ->{ where(route: "cms/tabs") }
  end

  class Crumb
    include Cms::Part::Model

    field :home_label, type: String

    permit_params :home_label

    default_scope ->{ where(route: "cms/crumb") }

    def home_label
      self[:home_label].presence || "HOME"
    end

    def render_html
      h = super.sub("ss-part", "")
      %(<div class="ss-part crumbs" data-href="#{url}"><span class="node">#{h}</span></div>)
    end
  end

  class << self
    @@plugins = []

    def plugin(path)
      name  = I18n.t("modules.#{path.sub(/\/.*/, '')}", default: path.titleize)
      name << "/" + I18n.t("cms.parts.#{path}", default: path.titleize)
      @@plugins << [name, path]
    end

    def plugins
      @@plugins
    end
  end
end
