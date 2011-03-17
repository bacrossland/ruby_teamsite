begin  
  require "nokogiri"
rescue LoadError  
  # Nokogiri is unavailable.  
  raise LoadError, "ERROR: Ruby TeamSite could not load nokogiri library. Please install nokogiri gem."
end

module RubyTeamSite
  class WFtask
  
    # Initialize the WFtask class by getting the task from the workflow system by ID.
    def initialize(task_id)
      @task_id = task_id.strip
      @ts_bin = ts_bin
      @task = `#{@ts_bin}/iwgetwfobj #{task_id.strip}`
      set_task_info(@task)
    end
  
    # Return the name of the task.
    def name
      return @task_name 
    end
    
    # Return the type of the task.
    def type
      return @task_type
    end
    
    # Return the id of the task.
    def id
      return @task_id 
    end
    
    # Return the XML output of the task.
    def xml
      return @task
    end
    
    # Return the areavpath of the task.
    def areavpath
      return @areavpath
    end
    
    # Callback to the workflow system to transition an external or cgi task.
    def callback(trans_num, comment=nil)
      # Only do a callback if the task is a cgitask or an externaltask.
      cb = ""
      if @task_type == 'cgitask' || @task_type == 'externaltask'
        cb = `#{@ts_bin}/iwcallback #{@task_id} #{trans_num} "#{comment}" 2>&1`
      end
      return cb
    end
    
    # Callback with success to the workflow system to transition an external or cgi task to it's success successor.
    def success(msg=nil)
      callback(0,msg)
    end
    
    # Callback with failure to the workflow system to transition an external or cgi task to it's failure successor.
    def failure(msg=nil)
      callback(1,msg)
    end
    
    # Add a file to the task. Comment is required but sending a blank is acceptable.
    def add_file(f,comment)
      file_path = "/#{f}"
      addfile = `#{@ts_bin}/iwaddtaskfile #{@task_id} #{file_path} "#{comment}" 2>&1`
      refresh
      return addfile
    end
    
    # Remove a file to the task.
    def remove_file(f)
      file_path = "/#{f}"
      rmfile = `#{@ts_bin}/iwrmtaskfile #{@task_id} #{file_path} 2>&1`
      refresh
      return rmfile
    end
    
    # Return an array of files attached to this task. 
    def files
      tsk = Nokogiri::XML(@task, nil, 'UTF-8')
      elmnt_files = tsk.css('files file')
      files = []
      if elmnt_files.empty? == false
        elmnt_files.each {|f| files << f.attribute('path').to_s}
      end
      return files
    end
    
    private
    
    # Create the location to the bin directory for TeamSite.
    def ts_bin
      iwhome = `iwgethome`
      ts_bin = iwhome + '/bin'
      ts_bin.gsub!(/\n/,'')
      ts_bin.strip!
      return ts_bin
    end
    
    # Set the information for the task.
    def set_task_info(task)
      tsk = Nokogiri::XML(task, nil, 'UTF-8')
      
      # Task name
      task_name = tsk.root.attribute('name')
      tname = task_name.to_s
      @task_name = tname.strip
      
      # Task type
      task_type = tsk.root.node_name
      ttype = task_type.to_s
      @task_type = ttype.strip
      
      # Task areavpath
      areavpath = tsk.css('areavpath').attribute('v')
      avp = areavpath.to_s
      @areavpath = avp.strip
    end
    
    # Refreshes the task variables to be current with what the workflow system has
    def refresh
      @task = `#{@ts_bin}/iwgetwfobj #{@task_id}`
      set_task_info(@task)
    end
  end
end