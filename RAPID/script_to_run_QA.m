
clear all

close all


%-----------------------------------
% INPUT NIFTI READER AND DATA PATH
%-----------------------------------

disp(' ')

%CJE
%path=input ('Please insert path of the Nifti reader: ','s');
%addpath(path)

work_path=pwd;

disp(' ')

%data_path=input ('Please insert path where diffusion data are stored: ','s');
%data_path='/home/sapje1/QA/DTI/temp/dtiqa+8396+20130114+085224/';

%cd(data_path)

disp(' ')

filename=input ('Please insert file name of DWI data: ','s');

disp(' ')

%maxb=input ('Please insert maximum b-value used (s/mm2): ','s');
%maxb=str2num(maxb);
maxb=3000;

sign=0.05;

doroi=1;

b_val=maxb*[0.2 0.4 0.6 0.8 1];

data1=load_nii(filename);

data_unordered=double(data1.img);

matrix_size=size(data_unordered,1);

n_slices=size(data_unordered,3);

disp(' ')

%n_b0=input ('Please insert number of b=0 images: ','s');
%n_b0=str2num(n_b0);
n_b0=1;

n_meas=size(data_unordered,4) -n_b0;

cd(work_path)

direction=importdata('grad_dir_12.txt');

direction_tot=importdata('Grad_dirs_QA_shuffled.txt');

data=order_data(data_unordered,direction_tot,n_b0);

n_dir=size(direction,1);

data_1=data(:,:,:,1:n_b0);

data_2=data_1;

data_3=data_1;

data_4=data_1;

data_5=data_1;

for j=1:size(b_val,2)
        
        eval(['data_' num2str(j) '=cat(4,data_' ...
            num2str(j)...
            ',data(:,:,:,n_b0+(j-1)*n_dir+1:n_b0+j*n_dir));'])
     
end

%-------------------------
%  MASK -> SELECT ROI
%-------------------------

x_min=matrix_size;

y_min=matrix_size;

x_max=0;

y_max=0;

z_min=0;

z_max=n_slices;


for slice=1:n_slices
    
    mask_slice=create_mask(data_1(:,:,slice,1),matrix_size);
    
    [mask_in, mask_out,count] = create_mask_in( mask_slice,3,1); 
    
    [row,col]=find(mask_in);
    
    if max(row)>x_max
        
        x_max=max(row);
    
    end
    
    if max(col)>y_max
        
        y_max=max(col);
    
    end
    
    if min(row)<x_min
        
        x_min=min(row);
    
    end
    
    if min(col)<y_min
        
        y_min=min(col);
    
    end
    
    
    mask(:,:,slice)=mask_in;
    
    %figure(1);imagesc(mask_in)

end

mask_box=calculate_box(mask,x_min,x_max,y_min,y_max,z_min,z_max);

%-------------------------------
%  CALCULATE DTI METRICS
%-------------------------------

[ADC,ADC_map,v1,l1,l3,I_map]=DTI_metrics(n_slices, matrix_size, n_b0,n_dir, direction, data_1,mask_box);

display(' ')
display('------------------------------------------------')
display('CHECKING RESIDUALS OF LINEAR FIT ln(S)=C*b_value')
display('------------------------------------------------')
display('* indicates rejection of the hypothesis that the residual distribution has mean=0')
display(' ')

[dec_res]=fit_lin(data_1,data_2,data_3,...
    data_4,data_5,n_slices,matrix_size,n_b0,n_dir,mask,b_val);

hfig = figure;
set(hfig, 'Position', [ 134    87   560   887 ]);

figure_residuals(dec_res,b_val)

%CJE
%display('Press a key to continue...')
%pause

%-------------------------------
%  CHECK FOR Gmax UNIFORMITY
%-------------------------------

display(' ')
display('---------------------------------------------')
display('CHECKING Gmax UNIFORMITY -> UNIFORMITY OF ADC')
display('---------------------------------------------')
display(' ')

%figure_Gmax_uniformity(ADC_map,n_slices);

%CJE
% figure_Gmax_uniformity(I_map,n_slices);
figure_Gmax_uniformity(I_map,n_slices, [x_max x_min y_max y_min]);

set(gcf,'Position',[50 50 1800 400])

%display('Press a key to continue...')

%pause

%-------------------------------
%  CHECK IF Gx=Gy=Gz
%-------------------------------

display(' ')
display('-----------------------------------------------------------------')
display('CHECKING IF Gx=Gy=Gz -> ORIENTATION OF PRINCIPAL EIGENVECTOR (PE)')
display('-----------------------------------------------------------------')
display(' ')

%figure; 

v1_boots=DTI_bootstrap(n_slices, matrix_size, n_b0,n_dir, direction, data_1,mask_box,100);

figure_Gx_Gy_Gz(v1,v1_boots)

%display('Press a key to continue...')

%pause


%-------------------------------
%  GRADIENT MISMATCH CORRECTION
%-------------------------------

display(' ')
display('-----------------------------')
display('GRADIENT MISMATCH CORRECTION')
display('-----------------------------')
display(' ')

choice=choice_num(0,2,0,'Do you want to correct for the gradient mismatch? 0=no, 1=yes, 2=include imaging gradients');

if choice==1
    
    x0=[1 1 1];
    
    min_val=0.5*x0;
    
    max_val=1.5*x0;
    
    parameter_hat=optimise2(n_slices, matrix_size, n_b0,n_dir,l3, direction,data_1,mask_box);
    
    parameter_hat=parameter_hat./max(parameter_hat);
    
    display(' ')
    
    fprintf('Correction parameters are %1.4f %1.4f %1.4f', parameter_hat)
    
    display(' ')
    
    direction_corr=repmat(parameter_hat,[size(direction,1) 1]).*direction;
    
    %[ADC_corr,ADC_map_corr,v1_corr,l1_corr,l3_corr]=DTI_metrics(n_slices, matrix_size, n_b0,n_dir, direction_corr, data_1,mask_box);

    %figure_Gx_Gy_Gz(v1_corr,v1_boots)
    
elseif choice==2
    
    [b_matrix_corr,parameter_hat]=correct_for_imaging_gradients(n_slices, matrix_size, n_b0,n_dir,l3, direction,data_1,mask_box,v1_boots);
    
end

display(' ')

display('QA DONE!')

display(' ')

str=date;

save(['QA_results_' str])




