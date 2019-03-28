class DashboardController < ApplicationController

    def index
        drop_breadcumbs :dashboard, root_path
    end
end
