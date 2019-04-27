%IHS PAN-Sharpening
clear all;close all;clc
load('pleiades_data.mat');
I = mean(I_MS,3);
Inew = ((I_PAN - mean2(I_PAN))/std2(I_PAN))*std2(I)+mean2(I);
fused = I_MS * 0;
for i = 1:1:4
    fused(:,:,i) = double(I_MS(:,:,i)) - I + Inew;
end

%% Figures & Performance
PSNR_IHS=PSNR(I_GT,fused);
 disp(['IHS PAN-Sharpening ---> Peak SNR = ' num2str(PSNR_IHS.ave)]);

figure; title('IHS PAN SHARPENING');
subplot(1,3,1); imshow(uint8(I_MS(:,:,1:3))); title('MULTISPECTRAL IMAGE');
subplot(1,3,2); imshow(uint8(I_PAN)); title('PAN-CHROMATIC IMAGE');
subplot(1,3,3); imshow(uint8(fused(:,:,1:3))); title('PAN SHARPENED IMAGE')
