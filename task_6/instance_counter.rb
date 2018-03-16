module InstanceCounter 
  @@instances = 0
  
  def self.instances
    @@instances
  end
  
  protected
  
  def register_instance
    @@instances += 1
  end  
end
