module RubyTeamSite
  class TeamSite
  
    # Initialize the TeamSite class.
    def initialize
      @iw_home = `iwgethome 2>&1`
      @ts_bin = ts_bin
      @ts_ver = `#{@ts_bin}/iwversion 2>&1`
    end  
    
    # Return the location that TeamSite is installed in.
    def iwhome
      return @iw_home
    end
    
    # Return the TeamSite version.
    def version
      return @ts_ver
    end
    
    # Have TeamSite lock a file. Comment is required but sending a blank is acceptable.
    def lock(f,comment,ownerid=nil)
      file_lock = `#{@ts_bin}/iwlock #{f} "#{comment}" #{ownerid unless ownerid.nil?} 2>&1`
      return file_lock
    end
    
    # Have TeamSite unlock a file.
    def unlock(f)
      file_lock = `#{@ts_bin}/iwunlock #{f} 2>&1`
      return file_lock
    end
    
    # Return file state in a hash.
    def file_state(f)
      fstate = `#{ts_bin}/iwfilestate -f script #{f} 2>&1`
      if fstate.include?(':')
        fstate.gsub!(/\n/,'')
        tmp_arr = ['error',fstate]
        fstate_hash = Hash[*tmp_arr.flatten]
      else
        fstate.gsub!(/\n/,':-:')
        fstate.gsub!('=',':-:')
        fstate_arr = fstate.split(":-:")
        fstate_hash = Hash[*fstate_arr.flatten]
      end
      
      return fstate_hash
    end
    private
    
    # Create the location to the bin directory for TeamSite.
    def ts_bin
      ts_bin = iwhome + '/bin'
      ts_bin.gsub!(/\n/,'')
      ts_bin.strip!
      return ts_bin
    end
  end
end
