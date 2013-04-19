# Create a bunch of users to play with in the CSA app
2..10.times do |i|
  user = User.create!(:id        => i,
                     :surname   => "Surname#{i}",
                     :firstname => "Firstname#{i}",
                     :email     => "cwl#{i}@aber.ac.uk",
                     :phone     => "01970 622422",
                     :grad_year => 1985)
  UserDetail.create!(:login => "cwl#{i}",
                    :password => "secret",
                    :password_confirmation => "secret",
                    :user => user,
                    :level => 5)
end
# Create one special admin user
user = User.create!(:surname   => "Loftus",
                   :firstname => "Chris",
                   :email     => "cwl@aber.ac.uk",
                   :phone     => "01970 622422",
                   :grad_year => 1985)
UserDetail.create!(:login => "admin",
                  :password => "taliesin",
                  :password_confirmation => "taliesin",
                  :user => user,
                  :level => 0)

# Create some dummy feeds
Feed.create!(:name => "twitter")
Feed.create!(:name => "facebook")
Feed.create!(:name => "email")
Feed.create!(:name => "RSS")
Feed.create!(:name => "atom")
Feed.create!(:name => "blog")

2..5.times do |c|
  broad = Broadcast.create!(:title => "test Job title",
                    :content => "test content",
                    :feed_type => Broadcast::JOB_S,
                    :user => user)
  job = Job.create!(:broadcast => broad)
  broad.job = job
  
  feed = Feed.find_by_name('blog')
  broad.feeds << feed if feed
end
2..5.times do |c|
  broad = Broadcast.create!(:title => "test News title",
                    :content => "test content",
                    :feed_type => Broadcast::NEWSBLOG_S,
                    :user => user)
  news = Newsblog.create!(:broadcast => broad)
  broad.newsblog = news
  
  feed = Feed.find_by_name('blog')
  broad.feeds << feed if feed
end


                              