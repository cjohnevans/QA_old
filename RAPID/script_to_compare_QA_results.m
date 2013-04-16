
clear all

close all


%-----------------------------------
% INPUT .MAT FILES OF QA
%-----------------------------------

disp(' ')

filename1=input ('Please insert file name of older QA result : ','s');
%QA_results_21-Mar-2012

disp(' ')

filename2=input ('Please insert file name of newer QA result : ','s');
%QA_results_26-Apr-2012

disp(' ')


%------------------------------------------------
% CHECK RESIDUALS OF LINEAR FIT ln(S)=C*b_value
%------------------------------------------------

display(' ')
display('------------------------------------------------')
display('CHECKING RESIDUALS OF LINEAR FIT ln(S)=C*b_value')
display('------------------------------------------------')
display(' ')

load(filename1,'dec_res','b_val')

dec_res_old=dec_res;

load(filename2,'dec_res')

figure;

figure_residuals_compare(dec_res_old,b_val,dec_res);

display('Press a key to continue...')

disp(' ')

pause

%-------------------------------
%  CHECK FOR Gmax UNIFORMITY
%-------------------------------

display(' ')
display('---------------------------------------------')
display('CHECKING Gmax UNIFORMITY -> UNIFORMITY OF ADC')
display('---------------------------------------------')
display(' ')

load(filename1,'ADC_map','n_slices')

ADC_map_old=ADC_map(1:15,1:15,1:15);

load(filename2,'ADC_map')

figure_Gmax_uniformity_compare(ADC_map_old,n_slices,ADC_map);

display('Press a key to continue...')

disp(' ')

pause


%-------------------------------
%  CHECK IF Gx=Gy=Gz
%-------------------------------

display(' ')
display('-----------------------------------------------------------------')
display('CHECKING IF Gx=Gy=Gz -> ORIENTATION OF PRINCIPAL EIGENVECTOR (PE)')
display('-----------------------------------------------------------------')
display(' ')

load(filename1,'v1_boots')

load(filename2,'v1')

figure_Gx_Gy_Gz_compare(v1,v1_boots)

display(' ')

display('QA COMPARE DONE!')

display(' ')







