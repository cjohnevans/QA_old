function[b_max]=calculate_bmax(TE_b0,snr,SNR_lim,Diff,maxG,T2)

TE=TE_b0;

difference=0.2;


while difference>0.1
    
    TE_old=TE;

    b_max=log(snr.*exp(-(TE-TE_b0)./T2)./SNR_lim)./Diff;

    TE=calculate_TE(maxG,b_max);

    difference=abs(TE-TE_old);

end