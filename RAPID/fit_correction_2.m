function [err]=fit_correction_2(x,n_slices, matrix_size, n_b0,n_dir,l3, direction,data_1000,mask)

a=x(1)./max(x);

b=x(2)./max(x);

c=x(3)./max(x);

disp_ideal=54.74;

for dir=1:n_dir
b_matrix(dir,:)= [(a*direction(dir,1))^2 (b*direction(dir,2))^2 (c*direction(dir,3))^2 ...
    2*a*b*direction(dir,1)*direction(dir,2) 2*a*c*direction(dir,1)*direction(dir,3)...
    2*b*c*direction(dir,2)*direction(dir,3)];
end

%DTI

count=0;

for k=1:n_slices

    for j=1:matrix_size
    
        for i=1:matrix_size
        
            if mask(i,j,k)
            
                count=count+1;

                S=squeeze(log(data_1000(i,j,k,n_b0+1:n_b0+n_dir)./data_1000(i,j,k,1)));
                
                D=-pinv(b_matrix)*S;
                
                D_tens=[D(1) D(4) D(5); D(4) D(2) D(6); D(5) D(6) D(3)];
                
                [v,l]=eig(D_tens);
                
                v1(count,:)=v(:,3);
            
            end
        end
        
    end
    
end

[mean_dir,disp]=watson_est(v1);

err=abs(disp_ideal-disp);

% 
% figure(1);plot(1:3*count,reshape(err,[count*3 1]),'.')
% drawnow
