# sampledata.rake


namespace :users do
  desc 'call "rake users:admin[email,password]" to add admin'
  task :admin, [:email, :pass] => :environment do |t, args|
    args.with_defaults(:email => "admin@fhpdefcontest.net", :pass => "awesomesauce")
    addadmin(args[:email], args[:pass])
  end
# Currently only the FIRST user added will become the admin user,
# regardless of explicitly setting the admin param to true. ~AMP

  desc 'call "rake users:user[email,password]" to add user'
  task :user, [:email, :pass] => [:environment, :admin] do |t, args|
    args.with_defaults(:email => "user@fhpdefcontest.net", :pass => "awesomesauce")
    adduser(args[:email], args[:pass])
  end
# As it stands the above :user task will invoke the :admin task before it runs.
# To disable dependency, remove the ":admin" that directly follows ":environment" ~AMP

  def addadmin(email, pass)    
    User.create(email: email, password: pass, password_confirmation: pass, admin: true)
  end

  def adduser(email, pass)    
    User.create(email: email, password: pass, password_confirmation: pass)
  end
end
