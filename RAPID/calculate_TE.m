function[TE]=calculate_TE(maxG,b_value)


g=4257;

smalldel=5:100;

delta = 15+smalldel;

b_value_trial = 10^-14*maxG.^2.*g^2*4.*(smalldel.^2)*pi^2*1000.*(delta-smalldel/3);

difference=abs(b_value_trial -b_value);

[val,ind]=min(difference);

del=delta(ind);

sdel=smalldel(ind);

TE=del+sdel+20;


