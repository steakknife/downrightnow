require 'downrightnow'
require 'trollop'

module DownRightNow
  module Util
    class CommandLine
      def exec
	begin
	  opts = Trollop::options do
	    version "DownRightNow (tm) unofficial ruby utility #{version}  (c) 2011 Barry Allard"
	    banner <<-EOS
	DownRightNow (tm) unofficial ruby utility #{version}  (c) 2011 Barry Allard

	    EOS
	    opt :verbose,         "Verbose display", :default => false
	    opt :error_on_outage, "Return error exit code if any outage", :default => false
	  end
	  drn = DownRightNow.new
	  puts drn.to_s opts[:verbose]
	  exit 1 if opts[:error_on_outage] && drn.any_outages?
	rescue => e
#	  puts e
#	  exit 1
          raise e
	end
      end # def exec
    end # class CommandLine
  end # module Util
end # module DownRightNow
