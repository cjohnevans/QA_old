function [opt] = choice_num(min,max,default,string)


%choise_num.m Choose a numeric value between min and max
%Version 1.3
%Federico Giove
%Tommaso Gili last modified 13/04/2011


opt=min-1;

disp(' ')

while (opt<min | opt>max)
    
    opt=input ([string,' (',num2str(min),'-',num2str(max),', default ',num2str(default),'): '],'s');
    
    if isempty(opt)
        
        opt=default;
        
    else
        opt=str2num(opt);
        
        if isempty(opt)
            
            opt=min-1;
            
        end
    end
    
    if (opt<min | opt>max)
        
        fprintf('wrong value!\n')
        
    end
    
end

return