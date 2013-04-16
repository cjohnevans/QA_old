function[mean_dir,disp]=watson_est(x_vec)

scatter_m=x_vec'*x_vec/size(x_vec,1);

[v,l]=eig(scatter_m);

mean_dir=v(:,3);

disp=asin(sqrt(1-max(max(l))));

disp=180*disp/pi;