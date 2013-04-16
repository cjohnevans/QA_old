function[data]=order_data(data_unordered,direction_tot,nb0)

module=sum(direction_tot.^2,2);

[module_sorted, ord]=sort(module);

ord=ord+nb0;

ord=[(1:nb0)';ord];

data=data_unordered(:,:,:,ord);

% for i=1:size(data,4)
%     
%     figure(1)
%     i
%     subplot (1,2,1)
%     imagesc(data_unordered(:,:,10,i),[0 3000])
%     subplot (1,2,2)
%     imagesc(data(:,:,10,i),[0 3000])
%     pause
% end
    
