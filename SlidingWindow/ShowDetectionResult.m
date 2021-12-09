function ShowDetectionResult(Picture,Objects, colours, imageNum ,resultsFolder)
% ShowDetectionResult(Picture,Objects)

Objects = resetOrigin(Objects);
  
% Show the picture
f = figure(1);
imshow(Picture), hold on;
% Show the detected objects
if(~isempty(Objects));
    for n=1:size(Objects,1)
        x1=Objects(n,1); y1=Objects(n,2);
        x2=x1+Objects(n,3); y2=y1+Objects(n,4);
        
        confidence = Objects(n,5)/ max(Objects(:,5));
        if confidence < 0
            c=1;
        else
            c=2;
        end
        
        plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],colours(c));
    end
end
drawnow
print([resultsFolder 'images\' imageNum '.jpg'], '-djpeg');

end