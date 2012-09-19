module Gretel
  module ResourceCrumbs

    def resource_crumb(name, &block)
      index_crumb name
      new_crumb name
      edit_crumb name
    end

    def index_crumb(name)
      crumb(name) do
        link(model_plural_name(name), send("#{name}_path"))
      end
    end

    def new_crumb(name)
      new_name = "new_#{name.to_s.singularize}".to_sym
      crumb(new_name) do
        link(resource_name(name), send("#{new_name}_path"))
        parent name
      end
    end

    def edit_crumb(name)
      edit_name = "edit_#{name.to_s.singularize}".to_sym
      crumb(edit_name) do |resource|
        link(resource_title(resource), send("#{edit_name}_path", resource))
        parent name
      end 
    end

    def model_plural_name(name)
      name.to_s.singularize.classify.safe_constantize.try(:model_name).try(:human).pluralize || name
    end

    def resource_name(name)
      name.to_s.singularize.classify.safe_constantize.try(:model_name).try(:human) || name
    end

    def resource_title(resource)
      resource.send([:to_breadcrumb, :name, :title, :to_s].find {|m| resource.respond_to?(m)})
    end

  end
end