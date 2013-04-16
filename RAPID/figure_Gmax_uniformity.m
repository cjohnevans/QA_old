function[]=figure_Gmax_uniformity(ADC_map,n_slices, plotlimits);

%CJE
%function[]=figure_Gmax_uniformity(ADC_map,n_slices);

%figure;

% CJE: matrix format as loaded in data_1, ...
%   data_1(PHASE, READ, SLICE, bval)
%   x = PHASE = rows; y=READ=columns


%CJE bit of a fudge here - temporarily set ADC_map as a percentge, for
%plotting, then set it back at the end...
ADC_temp = ADC_map;
ADC_map = ADC_map ./ (mean(mean(mean(ADC_map(:,:,:,1)))));
ADC_map = 100*(ADC_map-1);

for k=round(n_slices/2)
    
    % CJE set in figure_residuals
    %subplot(1,4,1)
    
    subplot(3,5,6)
    plot(smooth(mean(ADC_map(:,:,k,1),2)),'-r','LineWidth',1.5)
    
    hold on

    plot(1:size(mean(ADC_map(:,:,k,1),2)),smooth(mean(ADC_map(:,:,k,1),2)+std(ADC_map(:,:,k,1),[],2))','b',1:size(mean(ADC_map(:,:,k,1),2)),smooth(mean(ADC_map(:,:,k,1),2)-std(ADC_map(:,:,k,1),[],2))','b');
    
    %xlabel('PHASE')
    xlabel('READ')
    
    %CJE
    %ylabel(['Z=' num2str(k)])
    ylabel(['MD profile % (SLICE=' num2str(k) ')'])
    
    xlim([1 max(size(ADC_map,1))])
    
    ylim([min(mean(ADC_map(:,:,k,1),2)-3*std(ADC_map(:,:,k,1),[],2)) max(mean(ADC_map(:,:,k,1),2)+3*std(ADC_map(:,:,k,1),[],2))])
    
    %subplot(1,4,2)
      subplot(3,5,7)
  
    plot(smooth(mean(ADC_map(:,:,k,1),1)),'-r','LineWidth',1.5)
    
    hold on

    plot(1:size(mean(ADC_map(:,:,k,1),1),2),smooth(mean(ADC_map(:,:,k,1),1)+std(ADC_map(:,:,k,1),[],1))','b',1:size(mean(ADC_map(:,:,k,1),1),2),smooth(mean(ADC_map(:,:,k,1),1)-std(ADC_map(:,:,k,1),[],1))','b');
    
    %xlabel('READ')
    xlabel('PHASE')
    
    %CJE
    %ylabel(['Z=' num2str(k)])
    ylabel(['MD profile % (SLICE=' num2str(k) ')'])

    
    xlim([1 max(size(ADC_map,2))])
    
    ylim([min(mean(ADC_map(:,:,k,1),1)-3*std(ADC_map(:,:,k,1),[],1)) max(mean(ADC_map(:,:,k,1),1)+3*std(ADC_map(:,:,k,1),[],1))])
    
    hold on
     
end

%subplot(1,4,3)
subplot(3,5,8)

% CJE change smoothing
% plot(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)),3),'-r','linewidth',1.5)
plot(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2))),'-r','linewidth',1.5)

hold on

%CJE change smoothing and add more squeezes
%plot(1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)),3)),smooth(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)+std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2),3)','b',...
%    1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)),3)),smooth(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)-std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2),3)','b');
plot(1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)))), ...
   squeeze(smooth(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)+std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2))),'b', ...
   1:size(squeeze(smooth(squeeze(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2))))), ... 
   squeeze(smooth(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)-std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2))),'b');

xlim([1 max(size(ADC_map,3))])

ylim([min(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)-3*std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2)) max(mean(ADC_map(round(size(ADC_map,1)/2),:,:,1),2)+3*std(ADC_map(round(size(ADC_map,1)/2),:,:,1),[],2))])

xlabel('SLICE')

%CJE
%ylabel(['X=' num2str(round(size(ADC_map,1)/2))])
read_pos = round((plotlimits(3)+plotlimits(4))/2);
ylabel(['MD profile % (READ=' num2str(read_pos) ')'])

%subplot(1,4,4)
subplot(3,5,9)


%CJE change smoothing
%plot(smooth(squeeze(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)),3),'-r','linewidth',1.5)
plot(smooth(squeeze(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1))),'-r','linewidth',1.5)

hold on

%CJE change smoothing
%plot(1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,2)/2),:,:,1),2)),3)),smooth(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)+std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1),3)','b',...
%    1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,2)/2),:,:,1),2)),3)),smooth(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)-std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1),3)','b');
plot(1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,2)/2),:,:,1),2)))), ...
    squeeze(smooth(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)+std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1))),'b',...
    1:size(smooth(squeeze(mean(ADC_map(round(size(ADC_map,2)/2),:,:,1),2)))), ...
    squeeze(smooth(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)-std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1))),'b');

xlim([1 max(size(ADC_map,3))])

ylim([min(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)-3*std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1)) max(mean(ADC_map(:,round(size(ADC_map,2)/2),:,1),1)+3*std(ADC_map(:,round(size(ADC_map,2)/2),:,1),[],1))])

xlabel('SLICE')

%CJE
%ylabel(['Y=' num2str(round(size(ADC_map,2)/2))])
phase_pos = round((plotlimits(1)+plotlimits(2))/2);
ylabel(['MD profile % (PHASE=' num2str(phase_pos) ')'] );

% CJE end of the fudge
ADC_map = ADC_temp;


