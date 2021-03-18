function [U,S,V,threshold,w,sort1,sort2,sort3] = digitsThree(data1,data2,data3,feature)
    
    n1 = size(data1,2);
    n2 = size(data2,2);
    n3 = size(data3,3);
    [U,S,V] = svd([data1 data2 data3],'econ'); 
    datas = S*V';
    U = U(:,1:feature); % Add this in
    datas1 = datas(1:feature,1:n1);
    datas2 = datas(1:feature,n1+1:n1+n2);
    datas3 = datas(1:feature,n1+n2+1:n1+n2+n3);
    m1 = mean(datas1,2);
    m2 = mean(datas2,2);
    m3 = mean(datas3,2);

    Sw = 0;
    for k=1:n1
        Sw = Sw + (datas1(:,k)-m1)*(datas1(:,k)-m1)';
    end
    for k=1:n2
        Sw = Sw + (datas2(:,k)-m2)*(datas2(:,k)-m2)';
    end
    for k=1:n3
        Sw = Sw + (datas3(:,k)-m3)*(datas3(:,k)-m3)';
    end
    
    m = mean([m1;m2;m3]);
    Sb = (m1-m)*(m1-m).' + (m2-m)*(m2-m).'+(m2-m)*(m2-m).' ;
    
    [V2,D] = eig(Sb,Sw);
    [lambda,ind] = max(abs(diag(D)));
    w = V2(:,ind);
    w = w/norm(w,2);
    vdata1 = w'*datas1;
    vdata2 = w'*datas2;
    vdata3 = w'*datas3;
    
    % make sure that the order is data1, data2, data3
    if mean(vdata1)>mean(vdata2) && mean(vdata2)>mean(vdata3)
        w = -w;
        vdata1 = -vdata1;
        vdata2 = -vdata2;
        vdata3 = -vdata3;
    end
    
    
    % Don't need plotting here
    sort1 = sort(vdata1);
    sort2 = sort(vdata2);
    sort3 = sort(vdata3);
    t1 = length(sort1);
    t2 = length(sort2);
    t3 = 1;
    threshold = zeros(1,2);
    threshold(1) = (sort1(t1)+sort2(t2))/2;
    threshold(2) = (sort1(t2)+sort2(t3))/2;
  
end

