namespace :app do
  namespace :service do

    desc 'Checking reg codes and coupons'
    task :check => :environment do

      ServiceManager.check_all_services

    end
    
  end
end