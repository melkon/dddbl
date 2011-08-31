# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'find'

Find.find('/home/melkon/rb/dddbl/example') do |path|
  
  if path.end_with? 'sql'
    
    
    muff = File.new(path, 'r')
    
    while line = muff.gets

      if line =~ %r/^\[(.*?)\]$/
        
        p $1
        
      end
      
    end

  end
  
end