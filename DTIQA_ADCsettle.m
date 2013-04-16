% DTIQA_ADCsettle.m
%  Analyse setting data: 60mins, 5 loops of 41 vols -
%  Gradient order is 1b0 then 40dwis: 10 * [ 1 0 0; 0 1 0; 0 0 1; 0 0 0] ;
%  tensor95 (RAPIDQA_tensor60.dat)
% 
%  Require:
%     fname = filename of nii (unpacked) of DWI data.

fname = 'ADCxyz_60mins.nii';

bval = 3000;
loops = 5;
nvol_loop = 41;


dwdata=load_nifti(fname);
tmp = size(dwdata.vol);
nx = tmp(1);
ny = tmp(2);
nz = tmp(3);
nvol = tmp(4);
%ndwi = (nvol-1)/4;
ndwi = ((nvol_loop*loops)-1)/4;

% ignore first b0
dwix = zeros([nx ny nz ndwi]);
dwiy = zeros([nx ny nz ndwi]);
dwiz = zeros([nx ny nz ndwi]);
b0 = zeros([nx ny nz ndwi]);

jj=1;

for ll = 0:(loops-1)
    for ii = 2:4:nvol_loop
        volno = (ll*nvol_loop) + ii;
        dwix(:,:,:,jj) = dwdata.vol(:,:,:,(volno));
        dwiy(:,:,:,jj) = dwdata.vol(:,:,:,(volno+1));
        dwiz(:,:,:,jj) = dwdata.vol(:,:,:,(volno+2));
        b0(:,:,:,jj) = dwdata.vol(:,:,:,(volno+3));
        jj=jj+1;
    end
end
   
% create mask, from last b0 and all dwis
b0mean = mean(mean(mean(b0(:,:,:,50))));
dwixmean = mean(mean(mean(dwix(:,:,:,50))));
dwiymean = mean(mean(mean(dwiy(:,:,:,50))));
dwizmean = mean(mean(mean(dwiz(:,:,:,50))));

mask = double(b0>(b0mean*0.95)) * ...
    double(dwixmean>(dwixmean*0.95)) * ...
    double(dwiymean>(dwiymean*0.95)) * ...
    double(dwiymean>(dwiymean*0.95)) ;

b0 = b0 .* mask;
dwix = dwix .* mask;
dwiy = dwiy .* mask;
dwiz = dwiz .* mask;

ADCx =  - (1./ bval) * log(dwix ./ b0);
ADCy =  - (1./ bval) * log(dwiy ./ b0);
ADCz =  - (1./ bval) * log(dwiz ./ b0);
 
ADCx = ADCx .* mask;
ADCy = ADCy .* mask;
ADCz = ADCz .* mask;
 
ADCx(isnan(ADCx))=0;
ADCx(isinf(ADCx))=0;

ADCy(isnan(ADCy))=0;
ADCy(isinf(ADCy))=0;

ADCz(isnan(ADCz))=0;
ADCz(isinf(ADCz))=0;

mADCx = squeeze(mean(mean(mean(ADCx))));
mADCy = squeeze(mean(mean(mean(ADCy))));
mADCz = squeeze(mean(mean(mean(ADCz))));

tt = [1:(17*4): (17*50*4)] / 60;
%plot(tt, mADCx, tt, mADCy, tt, mADCz);
plot(tt, mADCx, tt, mADCy, tt, mADCz);

ylabel('ADC')
legend(['ADCx' ;'ADCy' ;'ADCz'])
xlabel('time (min)')

tmpx=make_nii(ADCx);
view_nii(tmpx);
