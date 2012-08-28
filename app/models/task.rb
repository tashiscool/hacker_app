class Task < ActiveRecord::Base
    
    belongs_to :list, :class_name => "List", :foreign_key => "list_id"
    
     def setParams(name, list_id)
        @name = name
        @list_id = list_id
        @done = false
    end

end
