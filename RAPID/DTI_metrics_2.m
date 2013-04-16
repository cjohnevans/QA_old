function[ADC,ADC_map,v1,l1,l3,I_map,S_map,b_matrix]=DTI_metrics_2(n_slices, matrix_size, n_b0,n_dir, direction,data_1000,mask,x)

a=x(1)./max(x);

b=x(2)./max(x);

c=x(3)./max(x);

d=x(4)./max(x);

e=x(5)./max(x);

f=x(6)./max(x);

% B-MATRIX
for dir=1:n_dir

    b_matrix1= [(a*direction(dir,1))^2 (b*direction(dir,2))^2 (c*direction(dir,3))^2 ...
    2*a*b*direction(dir,1)*direction(dir,2) 2*a*c*direction(dir,1)*direction(dir,3)...
    2*b*c*direction(dir,2)*direction(dir,3)];
    b_matrix2= [ direction(dir,1)*d direction(dir,2)*e direction(dir,3)*f ...
        1/2*(direction(dir,1)*e+direction(dir,2)*d) 1/2*(direction(dir,1)*f+direction(dir,3)*d) ...
        1/2*(direction(dir,2)*f+direction(dir,3)*e)];
    b_matrix(dir,:)=b_matrix1+b_matrix2;     

end

%DTI

count=0;

i_min=matrix_size;

j_min=matrix_size;

k_min=n_slices;

for k=1:n_slices
    
    for j=1:matrix_size
        
        for i=1:matrix_size
            
            if mask(i,j,k)
                
                count=count+1;
                
                I_map(i,j,k)=squeeze(data_1000(i,j,k,1));
                
                S_map(i,j,k)=squeeze(log(data_1000(i,j,k,n_b0+1)./data_1000(i,j,k,1)));

                S=squeeze(log(data_1000(i,j,k,n_b0+1:n_b0+n_dir)./data_1000(i,j,k,1)));
                
                D=-pinv(b_matrix)*S;
                
                resid(count)=sum((S+b_matrix*D).^2,1);
                
                D_tens=[D(1) D(4) D(5); D(4) D(2) D(6); D(5) D(6) D(3)];
                
                [v,l]=eig(D_tens);
                
                ADC(count)=sum(diag(l))/3;
                
                l1(count)=l(3,3);
                
                l3(count)=l(1,1);
                
                ADC_map(i,j,k)=sum(diag(l))/3;
                
                v1(count,:)=v(:,3);
                
                v2(count,:)=v(:,2);
                
                v3(count,:)=v(:,1);
                
                [th ph r]=cart2sph(v(1,3),v(2,3),v(3,3));
                
                theta(2*count-1)=th;
                
                phi(2*count-1)=ph;
                
                [th ph r]=cart2sph(-v(1,3),-v(2,3),-v(3,3));
                
                theta(2*count)=th;
                
                phi(2*count)=ph;
                
                if i<i_min
                    
                    i_min=i;
                end
                
                if j<j_min
                    
                    j_min=j;
                
                end
                
                if k<k_min
                    
                    k_min=k;
                
                end
                
                
            end
        end
    end
end


ADC_map(1:i_min-1,:,:)=[];

ADC_map(:,1:j_min-1,:)=[];

ADC_map(:,:,1:k_min-1)=[];

I_map(1:i_min-1,:,:)=[];

I_map(:,1:j_min-1,:)=[];

I_map(:,:,1:k_min-1)=[];

S_map(1:i_min-1,:,:)=[];

S_map(:,1:j_min-1,:)=[];

S_map(:,:,1:k_min-1)=[];





