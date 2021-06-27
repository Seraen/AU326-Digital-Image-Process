%input images
[x,cmap1]=imread('lena.jpg');
[y,cmap2]=imread('image.jpg');
%adjust the size and change to grey images
[~,~,l]=size(x);
if l==3
     x=rgb2gray(x);
end
[m,n,l]=size(y);
if l==3
     y=rgb2gray(y);
end
[a,b]=size(x);
y=imresize(y,[a,b]);
% Fourier transform
xf=fft2(x);
yf=fft2(y);
% the corresponding spectrum and phase angle
xf1=abs(xf);
xf2=angle(xf);
yf1=abs(yf);
yf2=angle(yf);
% move
s1=fftshift(xf);
s11=log(abs(s1)+1);
s2=fftshift(yf);
s22=log(abs(s2)+1);
% exchange the phase angles
xfr=xf1.*cos(yf2)+xf1.*sin(yf2).*1j;
yfr=yf1.*cos(xf2)+yf1.*sin(xf2).*1j;
% IFFT
xr=abs(ifft2(xfr));
yr=abs(ifft2(yfr));
% change to type uint8
xr=uint8(xr);
yr=uint8(yr);
% show
subplot(3,3,1);imshow(x);title('x the original image');
subplot(3,3,4);imshow(y);title('y the original image');
subplot(3,3,2);imshow(s11,[]);title('x spectrum');
subplot(3,3,3);imshow(xf2,[]);title('x phase angle');
subplot(3,3,5);imshow(s22,[]);title('y spectrum');
subplot(3,3,6);imshow(yf2,[]);title('y phase angle');
subplot(3,3,7);imshow(xr,[]);title('x spectrum with y phase angle');
subplot(3,3,8);imshow(yr,[]);title('y spectrum with x phase angle');