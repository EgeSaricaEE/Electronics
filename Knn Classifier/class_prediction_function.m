
function class_name=class_prediction(training_set,label_vector,inst_unk_lab,k)


%find distance by using Euclidean distance measure
dist=sqrt((inst_unk_lab(1,1)-training_set(:,1)).^2+(inst_unk_lab(1,2)-training_set(:,2)).^2);

%sort the distance values with indices from smallest to biggest and obtain
%indices array
[~,sorted_ind]=sort(dist);

%find class names of closest 'k' neighbors
class_names=label_vector(sorted_ind(1:k,1),1);

%predict the class of the data 
    if sum(class_names==2)>sum(class_names==1)
        class_name=2;
    else
        class_name=1;
    end
end