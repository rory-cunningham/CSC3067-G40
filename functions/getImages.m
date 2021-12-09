function [ Images ] = getImages( directory )

imagefiles = dir([directory '*.jpg']);      
n = length(imagefiles);

for i=1:n
   img = imread([directory imagefiles(i).name]);
      
   if(size(size(img), 2) == 2)
       setFigure = figure('Visible','off');
       img = ind2rgb(img, gray);
       close(setFigure);
   end
   
   Images(:,:,:,i) = uint8(img);
end

end