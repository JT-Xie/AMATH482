clear all; close all; clc

%% Load the data
[trainingdata, traingnd] = mnist_parse('train-images-idx3-ubyte', 'train-labels-idx1-ubyte');
trainingdata = double(reshape(trainingdata, size(trainingdata,1)*size(trainingdata,2), []));
traingnd = double(traingnd);

[testdata, testgnd] = mnist_parse('t10k-images-idx3-ubyte', 't10k-labels-idx1-ubyte');
testdata = double(reshape(testdata, size(testdata,1)*size(testdata,2), []));
testgnd = double(testgnd);  

%% SVD analysis
[U,S,V] = svd(trainingdata,'econ');

%%
% 4. On a 3D plot, project onto three selected V-modes (columns) colored by their digit label. For example,
% columns 2,3, and 5.

for label=0:9
    label_indices = find(traingnd == label);
    plot3(V(label_indices, 2), V(label_indices, 3), V(label_indices, 5),...
        'o', 'DisplayName', sprintf('%i',label), 'Linewidth', 2)
    hold on
end
xlabel('2nd V-Mode'), ylabel('3rd V-Mode'), zlabel('5th V-Mode')
title('Projection onto V-modes 2, 3, 5')
legend
set(gca,'Fontsize', 14)

%% plot S
figure(2)
plot(diag(S),'ko','Linewidth',2)
set(gca,'Fontsize',16,'Xlim',[0 80])

xlabel('modes'), ylabel('singular value')
title('Singular Value of Training Dataset')

%% 2 digits

% choose 0 and 3 as an example sucrate = 0.9913
sucRate = ones(9,9);
for i = 0:9
    for j = i+1:9
        if(i >= j)
            break
        end
        label1 = find(traingnd == i);
        label2 = find(traingnd == j);
        min_size = min(size(label1),size(label2));
        label1 = label1(1:min_size);
        label2 = label2(1:min_size);
        data1 = trainingdata(:,label1);
        data2 = trainingdata(:,label2);
        
        
        testlabel1 = find(testgnd == i);
        testlabel2 = find(testgnd == j);
        min_size = min(size(testlabel1),size(testlabel2));
        testlabel1 = testlabel1(1:min_size);
        testlabel2 = testlabel2(1:min_size);
        testdata1 = testdata(:,testlabel1);
        testdata2 = testdata(:,testlabel2);
        
        
        % training
        [U_train,S_train,V_train,threshold_train,w_train,sort_train1,sort_train2] = dc_trainer(data1,data2,784);
        
        % test
        TestSet = [testdata1 testdata2];
        TestNum = size(TestSet,2);
        TestMat = U_train'*TestSet; % PCA projection
        pval = w_train'*TestMat;
        
        ResVec = (pval > threshold_train);
        
        % 0s are correct and 1s are incorrect
        hiddenlabels = zeros(1,size(TestSet,2));
        hiddenlabels(size(TestSet,2)/2+1:end) = 1;
        err = abs(ResVec - hiddenlabels);
        errNum_svm = sum(err);
        sucRate(i+1,j+1) = 1 - errNum_svm/TestNum;
    end
end

%%
% Three digits
% choose 0,1,2 as an example, and find the accurancy of 0.5435
sucRate3 = [];
feature = 10;
for i = 0:9
    for j = i+1:9
        for k = j+1:9
            label1 = find(traingnd == i);
            label2 = find(traingnd == j);
            label3 = find(traingnd == k);
            min_size = min([size(label1,1) size(label2,1) size(label3,1)]);
            label1 = label1(1:min_size);
            label2 = label2(1:min_size);
            label3 = label3(1:min_size);
            data1 = trainingdata(:,label1);
            data2 = trainingdata(:,label2);
            data3 = trainingdata(:,label3);
            [U,S,V,threshold,w,sort1,sort2,sort3] = digitsThree(data1,data2,data3,feature);
            
            % test
            testlabel1 = find(testgnd == i);
            testlabel2 = find(testgnd == j);
            testlabel3 = find(testgnd == k);
            min_size = min([size(testlabel1,1),size(testlabel2,1),size(testlabel3,1)]);
            testlabel1 = testlabel1(1:min_size);
            testlabel2 = testlabel2(1:min_size);
            testlabel3 = testlabel3(1:min_size);
            testdata1 = testdata(:,testlabel1);
            testdata2 = testdata(:,testlabel2);
            testdata3 = testdata(:,testlabel3);
            
            TestSet = [testdata1 testdata2 testdata3];
            TestNum = size(TestSet,2);
            TestMat = U_train'*TestSet; % PCA projection
            pval = w_train'*TestMat;
            
            Res = zeros(1,size(pval,2));
            for k = 1:size(pval,2)
                if pval(k) > threshold(2)
                    Res(k) = 2;
                elseif pval(k) < threshold(1)
                    Res(k) = 0;
                else
                    Res(k) = 1;
                end
            end
            
            % 0s are correct and 1s are incorrect
            hiddenlabels = zeros(1,size(TestSet,2));
            hiddenlabels(size(TestSet,2)/3+1:2*size(TestSet,2)/3) = 1;
            hiddenlabels(1+2*size(TestSet,2)/3:end) = 2;
            err = (Res == hiddenlabels);
            errNum_svm = sum(err);
            suc_svm = 1 - errNum_svm/TestNum;
            sucRate3 = [sucRate3 suc_svm];
        end
    end
end

%% decision tree classifiers 

tree_train=fitctree(trainingdata.',traingnd,'MaxNumSplits',10,'CrossVal','on');
view(tree_train.Trained{1},'Mode','graph');
tree_Error = kfoldLoss(tree_train);
tree_accurancy = 1-tree_Error;

%% SVM classifier with training data, labels and test set
train_svm = (S*V' ./ max(S*V')).';
X = train_svm;
Y = traingnd;

Mdl = fitcecoc(X,Y);
test_labels = predict(Mdl,testdata.');
err_svm = (test_labels == testgnd);
errNum_svm = sum(err_svm);
suc_svm = 1 - errNum_svm/10000;
sucRate_svm = suc_svm;