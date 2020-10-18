clear;close all;clc;
H=rgb2gray(imread('image7.jpg'));
[row, col] = size(H);

subplot(2,2,1), imshow(H), title('The original image');
subplot(2,2,2), imhist(H), title('The histogram of the original image');

PMF = zeros(1, 256); 
for i = 1:row
    for j = 1:col
        PMF(H(i,j) + 1) = PMF(H(i,j) + 1) + 1; 
    end
end
PMF = PMF / (row * col);

CDF = zeros(1,256);
CDF(1) = PMF(1);
for i = 2:256
    CDF(i) = CDF(i - 1) + PMF(i);
end

Sk = zeros(1,256);
for i = 1:256
    Sk(i) = CDF(i) * 255;
end

Sk = round(Sk);
for i = 1:row
    for j = 1:col
        H(i,j) = Sk(H(i,j) + 1);
    end
end

subplot(2,2,3), imshow(H), title('The equalized image');
subplot(2,2,4), imhist(H), title('The histogram of the equalized image');