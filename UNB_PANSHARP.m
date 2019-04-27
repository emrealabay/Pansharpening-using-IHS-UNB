%UNB PAN Sharpening
clear all;close all;clc
load('pleiades_data.mat');

[rows,cols,bands] = size(I_MS);
pansharpened = zeros(rows,cols,bands);
synthetic_PAN = zeros(rows,cols);

A=zeros(cols*rows,4);
X=zeros(4,1);
B=zeros(cols*rows,1);

for i=1:4
    A(:,i)=reshape(I_MS(:,:,i)',[cols*rows,1]);
end
B=reshape(I_PAN',[cols*rows,1]);

X= inv(A'*A)*A'*B;
synthetic_PAN = (I_MS(:,:,1).*X(1,1)+I_MS(:,:,2).*X(2,1)+I_MS(:,:,3).*X(3,1)+I_MS(:,:,4).*X(4,1));

for i=1:4
    pansharpened(:,:,i)=(I_MS(:,:,i)./synthetic_PAN).*I_PAN;
end

PSNR_UNB=PSNR(I_GT,pansharpened);
disp(['UNB PAN-Sharpening ---> Peak SNR = ' num2str(PSNR_UNB.ave)]);
figure; title('UNB PAN SHARPENING');
subplot(1,3,1); imshow(uint8(I_MS(:,:,1:3))); title('MULTISPECTRAL IMAGE');
subplot(1,3,2); imshow(uint8(I_PAN)); title('PAN-CHROMATIC IMAGE');
subplot(1,3,3); imshow(uint8(pansharpened(:,:,1:3))); title('PAN SHARPENED IMAGE');

for i=1:4
    pansharpened(:,:,i)=(pansharpened(:,:,i)-min(min(min(pansharpened(:,:,i)))))./(max(max(max(pansharpened(:,:,i))))-min(min(min(pansharpened(:,:,i)))));
    I_MS(:,:,i)=(I_MS(:,:,i)-min(min(min(I_MS(:,:,i)))))./(max(max(max(I_MS(:,:,i))))-min(min(min(I_MS(:,:,i)))));
end
I_PAN=(I_PAN-min(min(I_PAN)))./(max(max(I_PAN))-min(min(I_PAN)));
imwrite(I_MS(:,:,1:3),'Multispectral.tiff');
imwrite(I_PAN,'PANChromatic.tiff');
imwrite(pansharpened(:,:,1:3),'Pansharpened.tiff');



    