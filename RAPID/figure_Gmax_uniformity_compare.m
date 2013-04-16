function[]=figure_Gmax_uniformity(ADC_map,n_slices,ADC_map_new);

figure;

for k=round(n_slices/2)
    
    subplot(1,4,1)
    
    plot(smooth(mean(ADC_map(:,:,k,1),2)),'-r','LineWidth',1.5)
    
    hold on

    plot(1:size(mean(ADC_map(:,:,k,1),2)),smooth(mean(ADC_map(:,:,k,1),2)+std(ADC_map(:,:,k,1),[],2))','r',1:size(mean(ADC_map(:,:,k,1),2)),smooth(mean(ADC_map(:,:,k,1),2)-std(ADC_map(:,:,k,1),[],2))','r');
    
    plot(smooth(mean(ADC_map_new(:,:,k,1),2)),'-b','LineWidth',1.5)
    
    m=smooth(mean(ADC_map(:,:,k,1),2));
    
    m_new=smooth(mean(ADC_map_new(:,:,k,1),2));
    
    sd=std(ADC_map(:,:,k,1),[],2);
    
    if any(m-3*sd>m_new) | any(m+3*sd<m_new)
        
        text(max(size(ADC_map,1))/2,mean(m)+2*mean(sd),['*'],'FontSize',20,'Color',[0 0 0],'HorizontalAlignment','center')
        
        display(' ')
    
        fprintf('Significant differences between QAs in PHASE DIRECTION!')
        
        display(' ')
    
    end
    
    xlabel('PHASE DIRECTION')
    
    ylabel(['Z=' num2str(k)])
    
    xlim([1 max(size(ADC_map,1))])
    
    ylim([min(mean(ADC_map(:,:,k,1),2)-3*std(ADC_map(:,:,k,1),[],2)) max(mean(ADC_map(:,:,k,1),2)+3*std(ADC_map(:,:,k,1),[],2))])
    
    subplot(1,4,2)
    
    plot(smooth(mean(ADC_map(:,:,k,1),1)),'-r','LineWidth',1.5)
    
    hold on

    plot(1:size(mean(ADC_map(:,:,k,1),1),2),smooth(mean(ADC_map(:,:,k,1),1)+std(ADC_map(:,:,k,1),[],1))','r',1:size(mean(ADC_map(:,:,k,1),1),2),smooth(mean(ADC_map(:,:,k,1),1)-std(ADC_map(:,:,k,1),[],1))','r');
    
    plot(smooth(mean(ADC_map_new(:,:,k,1),1)),'-b','LineWidth',1.5)
    
    m=smooth(mean(ADC_map(:,:,k,1),1));
    
    m_new=smooth(mean(ADC_map_new(:,:,k,1),1));
    
    sd=std(ADC_map(:,:,k,1),[],1)';
    
    if any(m-3*sd>m_new) | any(m+3*sd<m_new)
        
        text(max(size(ADC_map,2))/2,mean(m)+2*mean(sd),['*'],'FontSize',20,'Color',[0 0 0],'HorizontalAlignment','center')
        
        display(' ')
    
        fprintf('Significant differences between QAs in READ DIRECTION !')
        
        display(' ')
    
    end
    
    
    xlabel('READ DIRECTION')
    
    ylabel(['Z=' num2str(k)])
    
    xlim([1 max(size(ADC_map,2))])
    
    ylim([min(mean(ADC_map(:,:,k,1),1)-3*std(ADC_map(:,:,k,1),[],1)) max(mean(ADC_map(:,:,k,1),1)+3*std(ADC_map(:,:,k,1),[],1))])
    
    hold on
     
end

subplot(1,4,3)

plot(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)),3),'-r','linewidth',1.5)

hold on

plot(1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)),3)),smooth(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)+std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2),3)','r',...
    1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)),3)),smooth(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)-std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2),3)','r');

plot(smooth(squeeze(mean(ADC_map_new(round(size(ADC_map_new,1)/2),:,:,1),2)),3),'-b','linewidth',1.5)

m=smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)),3);

m_new=smooth(squeeze(mean(ADC_map_new(round(size(ADC_map_new,1)/2),:,:,1),2)),3);

sd=squeeze(std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2));

if any(m-3*sd>m_new) | any(m+3*sd<m_new)
    
    text(max(size(ADC_map,3))/2,mean(m)+2*mean(sd),['*'],'FontSize',20,'Color',[0 0 0],'HorizontalAlignment','center')
    
    display(' ')
    
    fprintf('Significant differences between QAs in READ DIRECTION !')
    
    display(' ')
    
end

xlim([1 max(size(ADC_map,3))])

ylim([min(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)-3*std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2)) max(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)+3*std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2))])

xlabel('SLICE DIRECTION')

ylabel(['X=' num2str(round(size(ADC_map,1)/2))])

subplot(1,4,4)

plot(smooth(squeeze(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)),3),'-r','linewidth',1.5)

hold on

plot(1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,2)/2),:,:,1),2)),3)),smooth(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)+std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1),3)','r',...
    1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,2)/2),:,:,1),2)),3)),smooth(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)-std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1),3)','r');

plot(smooth(squeeze(mean(ADC_map_new(:,round(size(ADC_map_new,2)/2),:,1),1)),3),'-b','linewidth',1.5)

m=smooth(squeeze(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)),3);

m_new=smooth(squeeze(mean(ADC_map_new(:,round(size(ADC_map_new,2)/2),:,1),1)),3);

sd=squeeze(std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1));

if any(m-3*sd>m_new) | any(m+3*sd<m_new)
    
    text(max(size(ADC_map,3))/2,mean(m)+2*mean(sd),['*'],'FontSize',20,'Color',[0 0 0],'HorizontalAlignment','center')
    
    display(' ')
    
    fprintf('Significant differences between QAs in READ DIRECTION !')
    
    display(' ')
    
end

xlim([1 max(size(ADC_map,3))])

ylim([min(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)-3*std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1)) max(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)+3*std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1))])

xlabel('SLICE DIRECTION')

ylabel(['Y=' num2str(round(size(ADC_map,2)/2))])


