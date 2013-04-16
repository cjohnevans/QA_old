% DTIQA_ADCxyz.m
%  Generate ADC maps for ADCxyz protocol in QA.
%  Gradient order is 1b0 then 40dwis: 10 * [ 1 0 0; 0 1 0; 0 0 1; 0 0 0] ;
%  tensor95 (RAPIDQA_tensor60.dat)
% 
%  Require:
%     fname = filename of nii (unpacked) of DWI data.

fname = 'smallballDWI.nii';

bval = 3000;

dwdata=load_nifti(fname);
tmp = size(dwdata.vol);
nx = tmp(1);
ny = tmp(2);
nz = tmp(3);
nvol = tmp(4);
ndwi = (nvol-1)/4;

% ignore first b0
dwix = zeros([nx ny nz ndwi]);
dwiy = zeros([nx ny nz ndwi]);
dwiy = zeros([nx ny nz ndwi]);

jj=1;
for volno = 2:4:nvol
    dwix(:,:,:,jj) = dwdata.vol(:,:,:,(volno));
    dwiy(:,:,:,jj) = dwdata.vol(:,:,:,(volno+1));
    dwiz(:,:,:,jj) = dwdata.vol(:,:,:,(volno+2));
    b0(:,:,:,jj) = dwdata.vol(:,:,:,(volno+3));  
    jj=jj+1;
end

ADCx =  - (1./ bval) * log(dwix ./ b0);
ADCy =  - (1./ bval) * log(dwiy ./ b0);
ADCz =  - (1./ bval) * log(dwiz ./ b0);


tmp=make_nii(ADCx);
view_nii(tmp);
