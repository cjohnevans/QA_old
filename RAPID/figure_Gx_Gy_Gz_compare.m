function[]=figure_Gx_Gy_Gz_compare(v1,v1_boots)

for i=1:size(v1_boots,2)
    
    [mean_dir,disp]=watson_est(squeeze(v1_boots(:,i,:)));
    
    dispersion(i)=disp;
    
    if i==1
        
        mean_dir_old=mean_dir;
        
        disp_old=disp;
        
    end
    
end

boundary_low=mean(dispersion)-3*std(dispersion);

boundary_high=mean(dispersion)+3*std(dispersion);

[mean_dir_new,disp_new]=watson_est(v1);

if boundary_high>=disp_new & boundary_low<=disp_new
    
    display(' ')
    
    display('No differences in PE distributions')
    
    display(' ')
    
else
    
    display(' ')
    
    display('Significant differences in PE distributions')
    
    display(' ')
    
    display(['Old attractor for x=' num2str(mean_dir_old(1)) ' y=' num2str(mean_dir_old(2)) ' z=' num2str(mean_dir_old(3))])
    
    display(['Old dispersion ' num2str(round(disp_old*10)/10) ' degrees'])
    
    display(' ')
    
    display(['New attractor for x=' num2str(mean_dir_new(1)) ' y=' num2str(mean_dir_new(2)) ' z=' num2str(mean_dir_new(3))])
    
    display(['New dispersion ' num2str(round(disp_new*10)/10) ' degrees'])
    
    display(' ')

end
