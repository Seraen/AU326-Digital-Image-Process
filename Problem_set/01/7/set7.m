clear;close all;clc;
H=rgb2gray(imread('image7.jpg'));

subplot(2,2,1);
imshow(H);
title('The original image');

subplot(2,2,2);
imhist(H);
title('The histogram of the original image');

subplot(2,2,3);
H2=histeq(H);
imshow(H2);
title('The equalized image');

subplot(2,2,4);
imhist(H2);
title('The histogram of the equalized image');