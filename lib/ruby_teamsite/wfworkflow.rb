begin  
  require "nokogiri"
rescue LoadError  
  # Nokogiri is unavailable.  
  raise LoadError, "ERROR: Ruby TeamSite could not load nokogiri library. Please install nokogiri gem."
end

module RubyTeamSite
  class WFworkflow
    
    # Initialize the WFworkflow class by getting the workflow from the workflow system by ID.
    def initialize(wf_id)
      @workflow_id = wf_id.strip
      @ts_bin = ts_bin
      @workflow = `#{@ts_bin}/iwgetwfobj #{wf_id.strip}`
      set_wf_info(@workflow)
    end
  
    # Return the name of the workflow.
    def name
      return @wf_name 
    end
    
    # Return the id of the workflow.
    def id
      return @workflow_id 
    end
    
    # Return the name of the workflow creator.
    def creator
      return @wf_creator 
    end
    
    # Return the name of the workflow owner.
    def owner
      return @wf_owner 
    end
    
    # Return the description of the workflow.
    def description
      return @wf_desc 
    end  
    
    # Return the XML output of the workflow.
    def xml
      return @workflow 
    end
    
    # Return a hash of variables for this workflow. The key is the name of the variable and the value is its value.
    def variables
      wf = Nokogiri::XML(@workflow, nil, 'UTF-8')
      elmnt_vars = wf.css('variables variable')
      wf_vars = Hash.new
      if elmnt_vars.empty? == false
        elmnt_vars.each {|v| wf_vars[v.attribute('key').to_s] = v.attribute('value').to_s}
      end
      return wf_vars
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
    
    # Set the information for the workflow.
    def set_wf_info(wf)
      workflow = Nokogiri::XML(wf, nil, 'UTF-8')
      
      # Workflow name
      wfname = workflow.root.attribute('name')
      wfn = wfname.to_s
      @wf_name = wfn.strip
       
      # Workflow owner
      wfowner = workflow.root.attribute('owner')
      wfo = wfowner.to_s
      @wf_owner = wfo.strip
      
      # Workflow creator
      wfcreator = workflow.root.attribute('creator')
      wfc = wfcreator.to_s
      @wf_creator = wfc.strip
      
      # Workflow description
      wfdesc = workflow.css('description').text
      wfd = wfdesc.to_s
      @wf_desc = wfd.strip
      
    end
  end
end