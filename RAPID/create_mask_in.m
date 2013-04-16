function [mask_in, mask_out,count] = create_mask_in(mask,pixel,count)

D=size(mask,1);
mask_in=zeros(D);
mask_out=zeros(D);
if pixel==1
    count=0;
end;
for k=1:pixel,
    mask_in=zeros(D);
    for d1=2:D-1,
        for d2=2:D-1,
            neighbor(d1,d2)=mask(d1-1,d2)+mask(d1+1,d2)+mask(d1,d2-1)+mask(d1,d2+1)...
                +mask(d1-1,d2-1)+mask(d1+1,d2+1)+mask(d1+1,d2-1)+mask(d1-1,d2+1);
            if neighbor(d1,d2)<8 && neighbor(d1,d2)>1 && mask(d1,d2)==1
                mask_out(d1,d2)=1;
            end;
            if neighbor(d1,d2)==8 && mask(d1,d2)==1
                mask_in(d1,d2)=1;
                if pixel==1
                count=count+1;
                end;
            end;
       end;
    end;
    mask(:,:)=mask_in(:,:);
end;