% create plots for EPI QA
% CJE April '10
% INPUT: fname=filename.nii.gz
% input filename should be brain extracted epi dataset (NIFTI)
%     as this gets rid of high variance from eyeballs 
% for bet need -S -F options
epi=load_nifti(fname);
PSCepi=diff(epi.vol,1,4);
episize=size(PSCepi);

xdim=episize(1);
ydim=episize(2);
zdim=episize(3);
nt=episize(4);

% threshold using fsl
cmd = ['/cubric/software/freesurfer/fsl/bin/fslstats ' fname ' -r' ];
[imgmin, imgmax]=system(cmd);
imgmax=str2num(imgmax);
imgmax=imgmax(2);

thresh = imgmax/10;

[aa, meanepi]=system(['/cubric/software/freesurfer/fsl/bin/fslstats ' fname ' -l ' num2str(thresh) ' -M']);
meanepi=str2num(meanepi);

PSCepi=100*(PSCepi./meanepi); % percent signal change
%PSCpercentile75=PSCepi(PSCepi, 75, 4);

meanvol=mean(epi.vol,4);
meanvol(:,:,zdim:64)=0;
meansag=flipdim(permute(meanvol, [3 2 1]),1);
meanrow=reshape(meansag, [xdim ydim*64]);
meansag_2d=cat(1, meanrow(:,(1:8*ydim)), meanrow(:,(1+8*ydim):(16*ydim)),  ...
      meanrow(:,(1+16*ydim):(24*ydim)), meanrow(:,(1+24*ydim):(32*ydim)), ...
      meanrow(:,(1+32*ydim):(40*ydim)), meanrow(:,(1+40*ydim):(48*ydim)), ...
      meanrow(:,(1+48*ydim):(56*ydim)), meanrow(:,(1+56*ydim):(64*ydim)) );


% Signal to Fluctuation Noise Ratio, SFNR (Glover) 
% NEED TO DEAL WITH LOW SIGNAL REGIONS IN SFNR CALC
noise=std(epi.vol,0,4);
noise(:,:,zdim:64)=0; %pad to 64 slices

SFNR = meanvol ./ noise;
%SFNRrow=reshape(SFNR, [xdim ydim*64]);
%SFNR_2d=cat(1, SFNRrow(:,(1:8*ydim)), SFNRrow(:,(1+8*ydim):(16*ydim)),  ...
%      SFNRrow(:,(1+16*ydim):(24*ydim)), SFNRrow(:,(1+24*ydim):(32*ydim)), ...
%      SFNRrow(:,(1+32*ydim):(40*ydim)), SFNRrow(:,(1+40*ydim):(48*ydim)), ...
%      SFNRrow(:,(1+48*ydim):(56*ydim)), SFNRrow(:,(1+56*ydim):(64*ydim)) );

% Display four slices: midslice-7 midslice-2 midslice+3 midslice+8
midslice = round(episize(3)/2);
dispslice = [midslice-7 midslice midslice+1 midslice+8 ];
SFNR_axdisp = cat(2, cat(1, rot90(SFNR(:,:,dispslice(1))), rot90(SFNR(:,:,dispslice(2)))), ...
    cat(1, rot90(SFNR(:,:,dispslice(3))), rot90(SFNR(:,:,dispslice(4)))));
%Display ROIs for SFNR calc
SFNR_axdisp(22:44, (64+22)) = 0;
SFNR_axdisp(22:44, (64+44)) = 0;
SFNR_axdisp(22, (64+22):(64+44)) = 0;
SFNR_axdisp(44, (64+22):(64+44)) = 0;
SFNR_axdisp((64+22):(64+44), 22) = 0;
SFNR_axdisp((64+22):(64+44), 44) = 0;
SFNR_axdisp((64+22), 22:44) = 0;
SFNR_axdisp((64+44), 22:44) = 0;

SFNR_midsl1 = rot90(SFNR(:,:,midslice));
SFNR_midsl1(22:44,22) = 0;
SFNR_midsl1(22:44,44) = 0;
SFNR_midsl1(22,22:44) = 0;
SFNR_midsl1(44,22:44) = 0;

SFNR_midsl2 = rot90(SFNR(:,:,midslice+1));
SFNR_midsl2(22:44,22) = 0;
SFNR_midsl2(22:44,44) = 0;
SFNR_midsl2(22,22:44) = 0;
SFNR_midsl2(44,22:44) = 0;


%do the same for sagital reslicing
SFNRsag=flipdim(permute(SFNR, [3 2 1]),1);
SFNRrow=reshape(SFNRsag, [xdim ydim*64]);
SFNRsag_2d=cat(1, SFNRrow(:,(1:8*ydim)), SFNRrow(:,(1+8*ydim):(16*ydim)),  ...
      SFNRrow(:,(1+16*ydim):(24*ydim)), SFNRrow(:,(1+24*ydim):(32*ydim)), ...
      SFNRrow(:,(1+32*ydim):(40*ydim)), SFNRrow(:,(1+40*ydim):(48*ydim)), ...
      SFNRrow(:,(1+48*ydim):(56*ydim)), SFNRrow(:,(1+56*ydim):(64*ydim)) );

% PSC stdev plot - better at picking up the rf.  Needs testing in
% script
% what does the stdev of PSC actually mean?
PSCstd=std(PSCepi,1,4);
PSCstd(:,:,zdim:64)=0;
PSCstd=flipdim(permute(PSCstd, [3 2 1]),1); %reformat to sag (rf
                                            %shows up better )

% ... not really CVrow (but saves on typing)	    
PSCrow=reshape(PSCstd, [xdim ydim*64]);   
PSC_2d=cat(1, PSCrow(:,(1:8*ydim)), PSCrow(:,(1+8*ydim):(16*ydim)),  ...
   PSCrow(:,(1+16*ydim):(24*ydim)), PSCrow(:,(1+24*ydim):(32*ydim)), ...
   PSCrow(:,(1+32*ydim):(40*ydim)), PSCrow(:,(1+40*ydim):(48*ydim)), ...
   PSCrow(:,(1+48*ydim):(56*ydim)), PSCrow(:,(1+56*ydim):(64*ydim)) );

PSC_std_MIP = max(PSCstd, [],3);
PSC_std_MIP = PSC_std_MIP(35:end,:);

%average PSC across each slice for all timepoints
PSCslice=squeeze(mean(mean(abs(PSCepi),1),2));

% Noise image (diff between vol 1 and 2)
noise_img = (epi.vol(:,:,(midslice:midslice+1),end-1) - epi.vol(:,:,(midslice:midslice+1),end));
drift_img = rot90(epi.vol(:,:,midslice,1) - epi.vol(:,:,midslice,end));

noise_img2(1:64,1:64,1:2) = 0;

for kk=1:2
    for ii=1:64
        for jj=1:64
            if(noise_img(ii,jj,kk) == 0)
                noise_img2(ii,jj,kk) = NaN;
            else
                noise_img2(ii,jj,kk) = noise_img(ii,jj,kk);
            end
        end
    end
end


noise_img_plot = rot90(noise_img(:,:,1));

%Summary Stats
SFNR_Summary = mean(mean(mean((SFNR(23:43,23:43,(midslice:midslice+1)))))); %Generate from 21x21x2 voxel at centre
Signal_Summary = mean(mean(mean(meanvol(:,:,(midslice:midslice+1)))));
SNR_Summary = Signal_Summary / (std(reshape(noise_img, [numel(noise_img) 1])));
SlicePSC_Max = max(max(PSCslice));
 
% Signal Timecourse
Signal_ROI = epi.vol(23:43,23:43,(midslice:midslice+1), :);
Signal_ROI = squeeze(mean(mean(mean(Signal_ROI, 3), 1),2));
Signal_ROI = (100*Signal_ROI ./ Signal_ROI(1))-100; % as percentage
% Linear fit of drift
%volno=[1:300];
volno=[1:length(Signal_ROI)];
[fitvals] = polyfit(volno, Signal_ROI',1);
x1= fitvals(1); x0 = fitvals(2);
DriftFit = x1*volno + x0;
LinearDrift=x1*300; % in % over whole timeseries

% SFNR from mid slices
h=figure;
set(h,'Visible','off');
set(h, 'Position', [ 134    87   560   887 ]);
subplot(4,2,1)
imagesc(SFNR_midsl1)
axis square
txt = ['SFNR (slice 1)' ];
title(txt);
colorbar
axis off

 subplot(4,2,2)
imagesc(SFNR_midsl2)
axis square
txt = ['SFNR (slice 2)' ];
title(txt);
colorbar
axis off

 subplot(4,2,4)
%imagesc(rot90(meanvol(:,:,midslice)));
% imagesc(rot90(epi.vol(:,:,midslice,1)));
% axis square
% txt = ['Typical Image (slice 1)' ];
% title(txt);
% colorbar
% axis off
plot(volno, Signal_ROI, 'b', volno, DriftFit, 'r');
txt = ['Signal Drift (%)' ];
title(txt);
xlabel('Volume');
%ylabel('Signal')

subplot(4,2,7)
imagesc(PSCslice)
colorbar
colormap(hot)
xlabel('Volume')
title('Slice % Signal Change')
ylabel('Slice')

subplot(4,2,5)
imagesc(noise_img_plot)
axis square
colorbar
%colorbar('location','southoutside')
axis off
title('Noise Image')

subplot(4,2,6)
imagesc(drift_img)
colorbar
%colorbar('location','southoutside')
axis off
title('Drift Image')
axis square

subplot(4,2,3)
imagesc(PSC_std_MIP, [0 max(PSC_std_MIP(:))]);
colormap hot
axis square
title('Fluctuation Map (MIP)');
colorbar
axis off

subplot(4,2,8)
axis off
whereisslash=strfind(fname, '/');
fname_short = fname( (whereisslash(end)+1):end ); 
tmp = [ 'Filename:' fname_short ];
tmp = regexprep(tmp, '_','-');
text(0,0.9, tmp, 'FontName', 'Courier');
tmp = [ 'SFNR    :' num2str(SFNR_Summary) ];
text(0,0.8, tmp, 'FontName', 'Courier');
tmp = [ 'SNR     :' num2str(SNR_Summary) ];
text(0,0.7, tmp, 'FontName', 'Courier');
tmp = [ 'Signal  :' num2str(Signal_Summary) ];
text(0,0.6, tmp, 'FontName', 'Courier');
tmp = [ 'Max \Delta Slice:' num2str(SlicePSC_Max) ' %' ];
text(0,0.5, tmp, 'FontName', 'Courier');
tmp = [ 'LinearDrift: ' num2str(LinearDrift) ];
text(0,0.4, tmp, 'FontName', 'Courier');


pdfname=[ fname(1:(end-7)) '.pdf' ];

% Use export_fig from matlabcentral
export_fig(pdfname)
outd = ['EPI QA analysis saved to ' pdfname ];
disp(outd)


%clear PSCsort PSCepi1

