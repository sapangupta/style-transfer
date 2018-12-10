
%%%%% Implementation of Approach 1 for preserving style in this paper
%%%%% https://arxiv.org/pdf/1606.05897v1.pdf
%%%%% Output is Style image which has the colour of the content image preserved

content=imread('content.jpg');
style=imread('style.jpg');
content=imresize(content,[512,512]);
style=imresize(style,[512,512]);
figure;
imshow(content);

meanC=double([mean(mean(content(:,:,1)));mean(mean(content(:,:,2)));mean(mean(content(:,:,3)))]);
meanS=double([mean(mean(style(:,:,1)));mean(mean(style(:,:,2)));mean(mean(style(:,:,3)))]);

sigmaC=zeros(3,3);
sigmaS=zeros(3,3);
N=size(content,1)*size(content,2);

for i=1:size(content,1)
    for j=1:size(content,2)
        xC=double(reshape(content(i,j,:),[3,1]));
        xS=double(reshape(style(i,j,:),[3,1]));
        sigmaC=sigmaC+(xC-meanC)*(xC-meanC)'/N;
        sigmaS=sigmaS+(xS-meanS)*(xS-meanS)'/N;
    end
end

A=sqrtm(sigmaC)*inv(sqrtm(sigmaS))
b=meanC-A*meanS

styleNew=zeros(size(style,1),size(style,2),3);
for i=1:size(style,1)
    for j=1:size(style,2)
    new=A*reshape(double(style(i,j,:)),[3,1])+b;
    styleNew(i,j,:)=reshape(new,[1,1,3]);
    end
end
figure;
imshow(uint8(styleNew));
