function mask_prova=calculate_box(mask,x_min,x_max,y_min,y_max,z_min,z_max)

intersect=1;

mask_prova=zeros(size(mask));

x=round((x_max-x_min)/2+x_min);

y=round((y_max-y_min)/2+y_min);

z=round((z_max-z_min)/2+z_min);

count=0;

while intersect
    
    count=count+1;
    
    try
    
        mask_prova(x-count:x+count,y-count:y+count,z-count:z+count)=1;
    
    catch
        
        intersect=0;
    
    end
    
    %figure(1); imagesc(mask_prova(:,:,z))
    
    if nnz(mask_prova)>nnz(mask_prova.*mask)
        
        intersect=0;
    
    end
     
end
