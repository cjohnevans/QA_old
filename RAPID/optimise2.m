function[gopt]=optimise2(n_slices, matrix_size, n_b0,n_dir,l3, direction,data_1000,mask)

g0=[1 1 1];

%annealing parameters
T=5000;
chi_T=0.99;
stop=0;
M=10;
counts=0;
gopt=g0;   
ni=0.01;
g0tot=g0;


err=fit_correction_2(g0,n_slices, matrix_size, n_b0,n_dir,l3, direction,data_1000,mask);
F0(1)=sum(sum(err));
Fopt=F0;
f(1)=F0;
while stop==0
    counts=counts+1;
    T=T*chi_T^(counts-1);
    spacing=exp(-1)./exp(-1./counts^2);
    for m=2:M
        %generating vectors
        index=round(rand(1)*3+0.5);
        gtest1=spacing*[rand(1)-0.5]/100+g0(index);
        gtest=g0;
        gtest(index)=gtest1;
        %calculate force
        err=fit_correction_2(gtest,n_slices, matrix_size, n_b0,n_dir,l3, direction,data_1000,mask);
        F=sum(sum(err));
        if F<Fopt
            g0=gtest;
            gopt=gtest;
            F0(m)=F;
            Fopt=F;
        else
            P=exp(-(F-Fopt)/T);
            trial=rand;
            if trial<P
                g0=gtest;
                F0(m)=F;
            else
                F0(m)=F0(m-1);
            end;
        end;
    end;
    
    g0=gopt;
    
    energy(counts)=(mean(F0,2)-min(F0))/mean(F0,2);
    f(counts)=Fopt;
    if energy(counts)<ni
        stop=1;
    end;
    
    figure(2); 
    subplot(2,1,1)
    plot((energy),'*')
    subplot(2,1,2)
    plot(f)
    %hold on
    %plot(1:size(f,2),Fopt,'*r')
    
    %figure(2);
    %gtot=flatten(gopt);
    %plotsphere(gtot);
    
end;

