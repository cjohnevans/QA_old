function [mask] = create_mask(b,D)

mask=zeros(D);
mean_intensity=mean(mean(b(:,:)));
for d1=1:D,
    for d2=1:D,
        if b(d1,d2)>0.7*mean_intensity
            mask(d1,d2)=1;
        end;
    end;
end;

