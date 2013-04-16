function[]=figure_residuals(dec_res, b_val)


count=0;

for j=1:size(dec_res,2)
    
    count=count+1;
    
    %CJE single output figure
    %subplot(1,size(dec_res,2),count)
    subplot(3,5,count)
    
    bins=hist((dec_res(:,j)),-1:0.025:1);
   
    plot([0 0], [0 1.3*max(bins)],'--r')
    
    hold on
        hist((dec_res(:,j)),-1:0.025:1)
    
   
    xlim([-1 1])
    
    ylim([0 1.3*max(bins)])
    
    %xlabel(['BVAL ' num2str(b_val(j))],'FontSize',7)
    xlabel(['BVAL ' num2str(b_val(j))])
    
    %ylabel(['DIR ' num2str(i)],'FontSize',7)
    
    
    m=mean(squeeze((dec_res(:,j))),1);
    
    sd=std(squeeze((dec_res(:,j))),1);
    
    if m-3*sd>0 | m+3*sd<0
        
        text(m,1.1*max(bins),['*'],'FontSize',10,'Color',[1 0 0],'HorizontalAlignment','center')
        
        display(' ')
    
        fprintf('Non-linearity of gradients for b=%5.0f!',b_val(j))
    
    end
    
    %set(gcf,'Position',[50 50 600 100])
    
end

