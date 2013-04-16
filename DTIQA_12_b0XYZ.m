% DTIQA_ADCxyz.m
%  Generate ADC maps for ADCxyz protocol in QA.
%  Gradient order is 12 b0, 12 Gx, 12 Gy, 12 Gz 
%  tensor95 (95_RAPIDQA_tensor60.dat, 1b0 + 47dir)
% 
%  Require:
%     fname = filename of nii (unpacked) of DWI data.

fname = 'tap13move.nii';
%fname = 'tap12nomove.nii';
%fname = 'smallball08.nii';

bval = 3000;

%dwdata=load_nifti(fname);
dwdata=load_nii(fname);
tmp = size(dwdata.img);
nx = tmp(1);
ny = tmp(2);
nz = tmp(3);
nvol = tmp(4);
ndwi = (nvol)/4;

b0 = dwdata.img(:,:,:,1:ndwi); 
dwiX = dwdata.img(:,:,:,(ndwi+1):(2*ndwi)); 
dwiY = dwdata.img(:,:,:,(2*ndwi+1):(3*ndwi)); 
dwiZ = dwdata.img(:,:,:,(3*ndwi+1):(4*ndwi)); 

stdb0 = std(double(b0),[],4);
%imagesc(stddwib0);
stddwiX = std(double(dwiX),[],4);
%imagesc(stddwiX);
stddwiY = std(double(dwiY),[],4);
%imagesc(stddwiY);
stddwiZ = std(double(dwiZ),[],4);
stdall(:,1:128) = stdb0;
stdall(:,129:256) = stddwiX;
stdall(:,257:384) = stddwiY;
stdall(:,385:512) = stddwiZ;
imagesc(stdall);

move_nomove(1:128,:) = move;
move_nomove(129:256,:) = no_move;


ADCx =  - (1./ bval) * log(dwix ./ b0);
ADCy =  - (1./ bval) * log(dwiy ./ b0);
ADCz =  - (1./ bval) * log(dwiz ./ b0);


tmp=make_nii(ADCx);
view_nii(tmp);
