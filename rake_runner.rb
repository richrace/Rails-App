# This makes running rake tasks (such as rake test:units) a little faster. 
# Run require './rake_runner' 
# this from a rails console. Rails console will load the rails environment once
# whereas rake 'task_id' will load rails environment
# every time. On my machine this reduced elapsed time from
# 80 secs to 25-30 secs for rake test:units
require 'rake'
class RakeRunner
	def self.run(task)
		r = Rake.application
		r.clear
		r.init
		r.load_rakefile
		r[task].invoke
	end
end
