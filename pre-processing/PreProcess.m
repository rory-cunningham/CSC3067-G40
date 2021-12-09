function [ Images ] = PreProcess( Images )
%Preprocesses images before being used in Models


for i=1:size(Images,3)
    
    Images(:,:,i) = histeq(Images(:,:,i));

    %Images(:,:,i) = contrastEnhance(Images(:,:,i));
    % Images(:,:,i) = normaliseRGBImage(Images(:,:,:,i));
end