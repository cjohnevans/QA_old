function[]=figure_Gx_Gy_Gz(v1,v1_boots)

for i=1:size(v1_boots,2)
    
[mean_dir,disp]=watson_est(squeeze(v1_boots(:,i,:)));

dispersion(i)=disp;

end

boundary_low=mean(dispersion)-3*std(dispersion);

boundary_high=mean(dispersion)+3*std(dispersion);

disp_ideal=54.74;

if boundary_high>=disp_ideal & boundary_low<=disp_ideal
    
    display(' ')
    
    display('Uniform orientation of PE!')
    
    display(' ')
    
else
    x_vec=squeeze(v1(:,:));
    
    [mean_dir,disp]=watson_est(x_vec);
    
    disp
    
    vector=cat(1,squeeze(v1(:,:)),-squeeze(v1(:,:)));

    % SPHERE PLOT
    %figure;

    vector=cat(1,squeeze(v1(:,:)),-squeeze(v1(:,:)));

    plotsphere_tot(vector,[0 0 0],2,[0 1 0]);

    set(gcf,'Position',[50 50 600 400])
    
    display(' ')
    
    display('Dispersion of PE is low -> PE are not uniformly distributed -> issue with Gx=Gy=Gz')
    
    display(['Attractor for x=' num2str(mean_dir(1)) ' y=' num2str(mean_dir(2)) ' z=' num2str(mean_dir(3))])
    
    display(' ')

end
