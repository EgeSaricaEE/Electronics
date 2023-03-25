
% import data

load('DATA.mat');


% obtain label vector, training set, validation data number, real class label

label_vector=DATA_tr(:,3);
training_set=DATA_tr(:,1:2);
valid_data_num=length(DATA_val);
real_class_label=DATA_val(:,3);

% find predicted class label

%create initially empty predicted class label and TCC vector
predicted_class_label=zeros(valid_data_num,1);
TCC=zeros(18,1);

%loop for 'k' parameter
for k=1:2:35

    %loop for all data in the validation data set
    for data_num=1:valid_data_num

        %obtain instance with the unknown label
        inst_unk_lab=DATA_val(data_num,1:2);

        %call the function and find class name
        predicted_class_label(data_num,1)=class_prediction(training_set,label_vector,inst_unk_lab,k);

        %calculate TCC
        TCC((k+1)/2,1)=sum(predicted_class_label==real_class_label)/valid_data_num*100;       
        
    end
    
%     %Print Confusion Matrix
%     confusion_matrix=[sum(predicted_class_label==1&real_class_label==1),...
%         sum(predicted_class_label==2&real_class_label==1);
%         sum(predicted_class_label==1&real_class_label==2),...
%         sum(predicted_class_label==2&real_class_label==2)]

end


% Figure for TCC vs k

plot(1:2:35,TCC)
xlabel('k Number')
ylabel('TCC (%)')


% Print Confusion Matrix for maximum TCC

%call the function and find class name
[~,ind_k_val]=max(TCC);
k_val=2*ind_k_val-1;
disp(['k value which gives maximum TCC is ',num2str(k_val)])
predicted_class_label(data_num,1)=class_prediction(training_set,label_vector,inst_unk_lab,k_val);
 

%Obtain Confusion Matrix
confusion_matrix=[sum(predicted_class_label==1&real_class_label==1),...
    sum(predicted_class_label==2&real_class_label==1);
    sum(predicted_class_label==1&real_class_label==2),...
    sum(predicted_class_label==2&real_class_label==2)];

%Print Confusion Table
prediction_cases={'Class 1(actual)';'Class 2(actual)'};
Class1_predicted=confusion_matrix(1:2,1);
Class2_predicted=confusion_matrix(1:2,2);
confusion_table=table(prediction_cases,Class1_predicted,Class2_predicted);
disp('Confusion Table for the k value:')
disp(confusion_table)


%class prediction function

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

