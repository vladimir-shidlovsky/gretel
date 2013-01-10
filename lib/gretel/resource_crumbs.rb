module Gretel
  module ResourceCrumbs

    def resource_crumb(name, options = {}, &block)
      options[:route_name] ||= name
      index_crumb name, options
      new_crumb name, options
      edit_crumb name, options
    end

    def index_crumb(name, options)
      crumb(name) do
        url = send("#{options[:route_name]}_path") rescue "#"
        link(model_plural_name(name), url, options)
      end
    end

    def new_crumb(name, options)
      new_name = "new_#{options[:route_name].to_s.singularize}".to_sym
      crumb(new_name) do
        url = send("#{new_name}_path") rescue "#"
        link(resource_name(name), url, options)
        parent name
      end
    end

    def edit_crumb(name, options)
      edit_name = "edit_#{options[:route_name].to_s.singularize}".to_sym
      crumb(edit_name) do |resource|
        url = send(["#{edit_name}_path", "#{name}_path"].find {|m| respond_to?(m)}) rescue "#"
        link(resource_title(resource), url, resource, options)
        parent name
      end 
    end

    def model_plural_name(name)
      name.to_s.classify.safe_constantize.try(:model_name).human(:count => :plural) rescue name
    end

    def resource_name(name)
      name.to_s.classify.safe_constantize.try(:model_name).try(:human) || name
    end

    def resource_title(resource)
      resource.send([:to_breadcrumb, :name, :title, :to_s].find {|m| resource.respond_to?(m)})
    end

  end
end
