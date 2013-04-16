%-----------------------------------
% SCRIPT TO CALCULATE THE SNR
%-----------------------------------

clear all

close all


%-----------------------------------
% INPUT NIFTI READER AND DATA PATH
%-----------------------------------

disp(' ')

path=input ('Please insert path of the Nifti reader: ','s');

addpath(path)

work_path=pwd;

disp(' ')

data_path=input ('Please insert path were b0 data are stored: ','s');

cd(data_path)

disp(' ')

filename=input ('Please insert file name of b0 data: ','s');

disp(' ')

chemicals=input ('Please insert name of chemical used: ','s');

switch chemicals
    
    case 'dodecane'
        
        Diff=0.0008;
        
        T2=163;
    
    otherwise
        
        disp(' ')
        
        Diff=input ('Please insert diffusion coefficient of chemical used (units mm2/s): ','s');
        
        Diff=str2num(Diff);
        
        T2=input ('Please insert T2 of chemical used (units ms): ','s');
        
        T2=str2num(T2);

end

disp(' ')

maxG=input ('Please insert maximum gradient amplitude (units Gauss/cm): ','s');

maxG=str2num(maxG);

disp(' ')

TE_b0=input ('Please insert TE (units ms): ','s');

TE_b0=str2num(TE_b0);

%-----------------------------------
% LOAD DATA
%-----------------------------------

data=load_nii(filename);

b0=double(data.img);


MDims = double(data.hdr.dime.dim);

MDims = MDims(2:4);

PDims = double(data.hdr.dime.pixdim);

PDims = PDims(2:4);

cd(work_path)

matrix_size=size(b0,1)

n_slices=size(b0,3)

b0(:,:,:,(end-6):end)=[];

n_dir=size(b0,4)

SNR=mean(b0,4)./std(b0,[],4);

mask=zeros(size(SNR));

%-----------------------------------
% SELECT ROI
%-----------------------------------

disp(' ')

disp('Please draw a ROI. Press a key when ready')

pause

figure(1);

imagesc(SNR(:,:,round(size(SNR,3)./2)))

temp=roipoly;

for slice=round(size(SNR,3)./2)

    mask(:,:,slice)=temp;

end

disp(' ')

snr=mean(((SNR(mask.*SNR>0))));

fprintf('Current SNR in selected ROI is %4.0f',snr)

disp(' ')

SNR_lim=5;

b_max=calculate_bmax(TE_b0,snr,SNR_lim,Diff,maxG,T2);

fprintf('Max b-value for current voxel size is %5.0f',round(b_max))

disp(' ')

opbmax=input ('Max b-value to test: ','s');

opbmax=str2num(opbmax);

TE_new=calculate_TE(maxG,opbmax);

SNR_lim_new=snr.*exp(-(TE_new-TE_b0)/T2).*exp(-opbmax.*Diff);

ratio=SNR_lim/SNR_lim_new;

vol_new=PDims(1)*PDims(2)*PDims(3)*ratio;

vox_size=nthroot(vol_new,3);

disp(' ')

fprintf('New isotropic voxel size is %2.2f',vox_size)

disp(' ')






