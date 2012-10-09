module Gretel
  module ResourceCrumbs

    def resource_crumb(name, &block)
      index_crumb name
      new_crumb name
      edit_crumb name
    end

    def index_crumb(name)
      crumb(name) do
        url = send("#{name}_path") rescue "#"
        link(model_plural_name(name), url)
      end
    end

    def new_crumb(name)
      new_name = "new_#{name.to_s.singularize}".to_sym
      crumb(new_name) do
        url = send("#{new_name}_path") rescue "#"
        link(resource_name(name), url)
        parent name
      end
    end

    def edit_crumb(name)
      edit_name = "edit_#{name.to_s.singularize}".to_sym
      crumb(edit_name) do |resource|
        url = send(["#{edit_name}_path", "#{name}_path"].find {|m| respond_to?(m)}) rescue "#"
        link(resource_title(resource), url, resource)
        parent name
      end 
    end

    def model_plural_name(name)
      name.to_s.singularize.classify.safe_constantize.try(:model_name).human(:count => :plural) rescue name
    end

    def resource_name(name)
      name.to_s.singularize.classify.safe_constantize.try(:model_name).try(:human) || name
    end

    def resource_title(resource)
      resource.send([:to_breadcrumb, :name, :title, :to_s].find {|m| resource.respond_to?(m)})
    end

  end
end