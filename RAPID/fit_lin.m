function[dec_res]=fit_lin(data_1000,data_2000,data_3000,data_4000,data_5000,n_slices,matrix_size,n_b0,n_dir,mask,b_val)

count=0;

for k=1:n_slices

    for j=1:matrix_size
    
        for i=1:matrix_size
        
            if mask(i,j,k)
            
                count=count+1;

                    d1=mean(squeeze(data_1000(i,j,k,n_b0+1:n_b0+n_dir)))/data_1000(i,j,k,1);
                    
                    d2=mean(squeeze(data_2000(i,j,k,n_b0+1:n_b0+n_dir)))/data_2000(i,j,k,1);
                    
                    d3=mean(squeeze(data_3000(i,j,k,n_b0+1:n_b0+n_dir)))/data_3000(i,j,k,1);
                    
                    d4=mean(squeeze(data_4000(i,j,k,n_b0+1:n_b0+n_dir)))/data_4000(i,j,k,1);
                    
                    d5=mean(squeeze(data_5000(i,j,k,n_b0+1:n_b0+n_dir)))/data_5000(i,j,k,1);
                    
                    dtot=[d1 d2 d3 d4 d5];
                    
                    dtot(dtot==0)=0.001;
                    
                    f=@(x,xdata)x(1)*xdata+x(2);
                    
                    options = optimset('Display','off');
 
                    coeff=lsqcurvefit(f,[-0.001 0],b_val', log(dtot)',[],[],options);
                    
                    %coeff=fit(b_val', log(dtot)','a*x+b');

                    lin=coeff(1)*b_val+coeff(2);

                    res=lin-log(dtot);
                    
                    dec_res(count,:)=res;
                    
                
            end
            
        end
        
    end
    
end