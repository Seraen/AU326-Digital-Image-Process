clear;
close all;
clc;

%read in the image
origin = im2double(imread('image.png'));
origin=im2bw(origin);
[m,n] = size(origin);
figure(1);imshow(origin);title('The original image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%4-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I1 = origin;
%pad the array with 1 which means creating a white border to the image
f = padarray(I1,[1 1],1);
[m,n] = size(f);

%collect the border
objects = [];
for i1=1:1:m
    objects=[objects i1];
end

for i2=1+m*(n-1):1:n*m
    objects=[objects i2];
end

for i3=2:1:n-1
    objects=[objects 1+(i3-1)*m];
    objects=[objects i3*m];
end

%extract the connected components
cc=bwconncomp(f,4);
numPixels = cellfun(@numel,cc.PixelIdxList);

%compare the border with the connected components
for k = 1:1:cc.NumObjects
    if isempty(intersect(objects,cc.PixelIdxList{k})) == 1
       f(cc.PixelIdxList{k}) = 0;
    end
end

%cut off the border and get the particles merged with the boundary
f1 = imcrop(f,[2 2 n-3 m-3]);

%show the particles merged with the boundary
figure(2);imshow(f1);title('The particles merging with the boundary');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%4-2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I2 = origin;

%extract the connected components
cc=bwconncomp(I2,4);
numPixels = cellfun(@numel,cc.PixelIdxList);

%extract the non-overlapping particles
for k = 1:1:cc.NumObjects
    if numPixels(k)>400
       I2(cc.PixelIdxList{k}) = 0;
    end
end

figure(3);imshow(I2);title('Non-overlapping particles');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%4-3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I3 = origin;

%substract non-overlapping particles from all particles
I3 = I3 - I2;

figure(4);imshow(I3);title('Overlapping particles');
