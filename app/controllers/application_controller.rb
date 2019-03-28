class ApplicationController < ActionController::Base

    def drop_breadcumbs(slice, route = nil)
        @breadcumb = '' if @breadcumb.nil?
        @breadcumb += if route.present? 
            "<a href=\"#{route}\" class=\"breadcrumb-item active\" aria-current=\"page\">#{slice.to_s.capitalize.gsub("_", " ")}</a>"
        else
            "<li class=\"breadcrumb-item active\" aria-current=\"page\">#{slice.to_s.capitalize.gsub("_", " ")}</li>"
        end
    end
end
