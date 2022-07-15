% ArchiveUpdateTight2
function[Ax,Ay] = ArchiveUpdateTight2 (Ax0, Ay0, Px, Py, eps, Delta)

   Ax = Ax0; 
   Ay = Ay0;
      
   nP = size(Py,1);
   
   for i = 1:nP,
       nA = size(Ay,1);
       %check if-condition
       added = 0;
       discard_1 = 0;
       discard_2 = 0;
       discard_edom = 0;
       discard_gap = 0;
       for j=1:nA,
         Ay(j,:);
         Py(i,:);
         if dominance(Ay(j,:)-eps,Py(i,:)),
             discard_1 = 1;
         end
         if dominance(Ay(j,:),Py(i,:)),
             discard_edom = 1;
         end
         if is_in_box(Ay(j,:),Py(i,:),Delta),
             discard_gap = 1;
         end      
       end    
       
       if discard_1 == 0 | (discard_edom==0 & discard_gap==0),
          % add p to archive and clean it
          added = 1;
          Ax(end+1,:) = Px(i,:);
          Ay(end+1,:) = Py(i,:);
          [Ax,Ay] = nondom (Ax,Ay);
       end   
       
       if added == 0,
         I = [];
         index = 1;
         nA = length (Ay(:,1));
         for j = 1:nA,
           if dominance(Py(i,:),Ay(j,:)),
              added = 1;
           else
               I(index) = j;
               index = index + 1;
           end
         end
         Ax = Ax(I,:);
         Ay = Ay(I,:);
         if added==1,
             Ax(end+1,:) = Px(i,:);
             Ay(end+1,:) = Py(i,:);
         end
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
