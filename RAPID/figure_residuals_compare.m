function[]=figure_residuals(dec_res, b_val,dec_res_new)


count=0;

differences=0;

for j=1:size(dec_res,2)
    
    count=count+1;
    
    subplot(1,size(dec_res,2),count)
    
    hist((dec_res(:,j)),-1:0.1:1)
    
    bins=hist((dec_res(:,j)),-1:0.1:1);
    
    xlim([-1 1])
    
    ylim([0 1.3*max(bins)])
    
    xlabel(['BVAL ' num2str(b_val(j))],'FontSize',7)
    
    %ylabel(['DIR ' num2str(i)],'FontSize',7)
    
    hold on
    
    plot([0 0], [0 1.3*max(bins)],'--r')
    
    m=mean(squeeze((dec_res(:,j))),1);
    
    m_new=mean(squeeze((dec_res_new(:,j))),1);
    
    sd=std(squeeze((dec_res(:,j))),1);
    
    
    if m-3*sd>m_new | m+3*sd<m_new
        
        text(m,1.1*max(bins),['*'],'FontSize',10,'Color',[1 0 0],'HorizontalAlignment','center')
        
        display(' ')
    
        fprintf('Significant differences between QAs for b=%5.0f!',b_val(j))
        
        display(' ')
        
        differences=1;
    
    end
    
    set(gcf,'Position',[50 50 600 100])
    
end

if differences
        
        display(' ')
    
        fprintf('No significant differences betwee QAs!')
        
        display(' ')
        
end


