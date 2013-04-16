function[b_matrix,parameter_hat]=correct_for_imaging_gradients(n_slices, matrix_size, n_b0,n_dir,l3, direction,data_1,mask_box,v1_boots)

    parameter_hat=optimise3(n_slices, matrix_size, n_b0,n_dir,l3, direction,data_1,mask_box);
    
    parameter_hat=parameter_hat./max(parameter_hat);
    
    display(' ')
    
    fprintf('Correction parameters are %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f', parameter_hat)
    
    display(' ')    
    
    [ADC_corr,ADC_map_corr,v1_corr,l1_corr,l3_corr,b_matrix]=DTI_metrics_2(n_slices, matrix_size, n_b0,n_dir, direction, data_1,mask_box,parameter_hat);

    figure_Gx_Gy_Gz(v1_corr,v1_boots)