% ArchiveUpdateP_Qeps
function[Ax,Ay] = ArchiveUpdateP_QepsXY (Ax0, Ay0, Px, Py, eps, DeltaX, DeltaY)

   Ax = Ax0; 
   Ay = Ay0;
   
   nA = size(Ay0,1);
   nP = size(Py,1);
   
   for i = 1:nP,
       %check if-condition
       discard = 0;
       for j=1:nA,
         if dominance(Ay(j,:)+eps,Py(i,:)) | (is_in_box(Py(i,:),Ay(j,:),DeltaY)==1 & (is_in_box(Px(i,:),Ax(j,:),DeltaX)==1)),
             discard = 1;
             break;
         end
       end  
       if discard == 0,
          index = []; 
          for j = 1:nA,
              if dominance(Py(i,:)+eps+DeltaY,Ay(j,:))==0,
                   index(end+1) = j;
              end    
          end    
          index;
          Ax = [Ax(index,:);Px(i,:)];
          Ay = [Ay(index,:);Py(i,:)];
          nA = length (Ay(:,1));
       end   
   end    


%subfunctions
function dom = dominance(a,b)
   dom = prod(double(a<=b));
return;   

function in = is_in_box(y,ya,Delta)
   for i=1:length(y),
       if abs(y(i)-ya(i))>Delta(i),
           in = 0;
           return;
       end    
   end    
   in = 1;
return;
