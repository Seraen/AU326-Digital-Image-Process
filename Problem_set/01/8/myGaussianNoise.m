function [B] = myGaussianNoise (mean,var)
    A=rgb2gray(imread('image8.jpg'));
    [m,n,~]=size(A);
    y=mean+sqrt(var)*randn(m,n); %aGaussian distribution matrix
    B=double(A)/255;%for easier calculation
    B=B+y;%add noise
    B=B*255;%transform to 0~255
    B=uint8(B);%transform to uint8
end
