foregroundDetector = vision.ForegroundDetector('NumGaussians',3, ...
    'NumTrainingFrames',50);
videoReader = vision.VideoFileReader('Count4.mp4');
for i =1:150
   frame = step(videoReader);
   foreground=step(foregroundDetector,frame);
end
se = strel('square',3);
filteredForeground=imopen(foreground,se);
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort',true,...
    'AreaOutputPort',false,'CentroidOutputPort',false,...
    'MinimumBlobArea',150);
bbox = step(blobAnalysis,filteredForeground);
videoPlayer = vision.VideoPlayer('Name','Detected Cars');
videoPlayer.Position(3:4) = [650,400];
se=strel('square',3);
countint=0;
while ~isDone(videoReader)
    frame = step(videoReader);
    foreground=step(foregroundDetector,frame);
    filteredForeground=imopen(foreground,se);
    bbox=step(blobAnalysis,filteredForeground);
    result=insertShape(frame,"rectangle",bbox,'Color','green');
    numCars=size(bbox,1);
    result =insertText(result, [320,320],numCars,'BoxOpacity',1, ...
        'FontSize',32);
    step(videoPlayer,result);
end
release(videoReader);
