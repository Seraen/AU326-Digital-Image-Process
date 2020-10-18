function[B] = myGaussianFilter(A)
    [row,col]=size(A);
    sigma = 1.6;      
    N = 9;            
    N_row = 2*N+1;

    %Gaussian template
    H = [];                                        
    for i=1:N_row
        for j=1:N_row
            numerator=double((i-N-1)^2+(j-N-1)^2);
            H(i,j)=exp(-numerator/(2*sigma*sigma))/(2*pi*sigma);
        end
    end
    H=H/sum(H(:));  %normalization            

    %processed image
    B=zeros(row,col);            
    M=zeros(row+2*N,col+2*N);    
    for i=1:row                           
        for j=1:col
            M(i+N,j+N)=A(i,j);
        end
    end
    
    temp=[];
    for ai=N+1:row+N
        for aj=N+1:col+N
            temp_row=ai-N;
            temp_col=aj-N;
            temp=0;
            for bi=1:N_row
                for bj=1:N_row
                    temp= temp+(M(temp_row+bi-1,temp_col+bj-1)*H(bi,bj));
                end
            end
            B(temp_row,temp_col)=temp;
        end
    end
    B=uint8(B);
    
end