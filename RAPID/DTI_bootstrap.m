function[v1]=DTI_bootstrap(n_slices, matrix_size, n_b0,n_dir, direction,data_1000,mask,n_boots)


% B-MATRIX
for dir=1:n_dir
    
    b_matrix(dir,:)= [direction(dir,1)^2 direction(dir,2)^2 direction(dir,3)^2 ...
        2*direction(dir,1)*direction(dir,2) 2*direction(dir,1)*direction(dir,3)...
        2*direction(dir,2)*direction(dir,3)];
    
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
                
                resid=S+b_matrix*D;
                
                for i=1:n_boots
                    
                    if i==1
                        
                        sign=ones(size(resid));
                        
                    else
                    
                        sign=2*round(rand(size(resid)))-1;
                    
                    end
                    
                    resid1=resid.*sign;
                    
                    S_boot=-b_matrix*D+resid1;
                    
                    D1=-pinv(b_matrix)*S_boot;
                    
                    D_tens=[D1(1) D1(4) D1(5); D1(4) D1(2) D1(6); D1(5) D1(6) D1(3)];
                
                    [v,l]=eig(D_tens);

                    v1(count,i,:)=v(:,3);

                end
            end
        end
    end
end






