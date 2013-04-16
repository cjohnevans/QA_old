function[]=figure_Gmax_uniformity_normalised(ADC_map,n_slices);

l=5;

figure;

for k=round(n_slices/2)
    
    subplot(1,4,1)
    
    aa=100*(mean(ADC_map(:,:,k,1),2)-mean(mean(ADC_map(:,:,k,1),2)))./mean(mean(ADC_map(:,:,k,1),2));
    
    bb=100*std(ADC_map(:,:,k,1),[],2)./mean(mean(ADC_map(:,:,k,1),2));
    
    plot(smooth(aa,3),'-r','LineWidth',1.5)
    
    hold on

    plot(1:size(mean(ADC_map(:,:,k,1),2)),smooth((aa+bb)',3),'b',1:size(mean(ADC_map(:,:,k,1),2)),smooth((aa-bb)',3),'b');
    
    xlabel('PHASE DIRECTION')
    
    ylabel(['Z=' num2str(k)])
    
    xlim([1 max(size(ADC_map,1))])
    
    %ylim([min(mean(ADC_map(:,:,k,1),2)-mean(mean(ADC_map(:,:,k,1),2))-3*std(ADC_map(:,:,k,1),[],2)) max(mean(ADC_map(:,:,k,1),2)-mean(mean(ADC_map(:,:,k,1),2))+3*std(ADC_map(:,:,k,1),[],2))])
    ylim([-l l])
    
    subplot(1,4,2)
    
    aa=100*(mean(ADC_map(:,:,k,1),1)-mean(mean(ADC_map(:,:,k,1),1)))./mean(mean(ADC_map(:,:,k,1),1));
    
    bb=100*std(ADC_map(:,:,k,1),[],1)./mean(mean(ADC_map(:,:,k,1),1));
    
    plot(smooth(aa,3),'-r','LineWidth',1.5)
    
    hold on

    plot(1:size(mean(ADC_map(:,:,k,1),1),2),smooth((aa+bb)',3),'b',1:size(mean(ADC_map(:,:,k,1),1),2),smooth((aa-bb)',3),'b');
    
    xlabel('READ DIRECTION')
    
    ylabel(['Z=' num2str(k)])
    
    xlim([1 max(size(ADC_map,2))])
    
    %ylim([min(mean(ADC_map(:,:,k,1),1)-3*std(ADC_map(:,:,k,1),[],1)) max(mean(ADC_map(:,:,k,1),1)+3*std(ADC_map(:,:,k,1),[],1))])
    ylim([-l l])
    
    hold on
     
end

subplot(1,4,3)

aa=100*squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)-mean(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2))))./mean(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)));

bb=100*squeeze(std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2))./mean(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)));

plot(smooth(aa,3),'-r','linewidth',1.5)

hold on

plot(1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)),3)),smooth((aa+bb)',3),'b',...
    1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)),3)),smooth((aa-bb)',3),'b');

xlim([1 max(size(ADC_map,3))])

%ylim([min(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)-3*std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2)) max(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)+3*std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2))])
ylim([-l l])

xlabel('SLICE DIRECTION')

ylabel(['X=' num2str(round(size(ADC_map,1)/2))])

subplot(1,4,4)

aa=100*squeeze(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)-mean(squeeze(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1))))./mean(squeeze(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)));

bb=100*squeeze(std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1))./mean(squeeze(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)));

plot(smooth(aa,3),'-r','linewidth',1.5)

hold on

plot(1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,2)/2),:,:,1),2)),3)),smooth(aa-bb)','b',...
    1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,2)/2),:,:,1),2)),3)),smooth(aa+bb)','b');

xlim([1 max(size(ADC_map,3))])

%ylim([min(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)-3*std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1)) max(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)+3*std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1))])
ylim([-l l])

xlabel('SLICE DIRECTION')

ylabel(['Y=' num2str(round(size(ADC_map,2)/2))])


