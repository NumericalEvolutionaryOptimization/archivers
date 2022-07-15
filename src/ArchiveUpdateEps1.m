% ArchiveUpdateEps1  
function[Ax,Ay] = ArchiveUpdateEps1 (Ax0, Ay0, Px, Py, eps, Delta)

   Ax = Ax0; 
   Ay = Ay0;
   
   nA = size(Ay0,1);
   nP = size(Py,1);
   
   for i = 1:nP,
       %check if-condition
       discard = 0;
       for j=1:nA,
         if dominance(Ay(j,:)-Delta*eps,Py(i,:)),
             discard = 1;
             break;
         end
       end    
       if discard == 0,
          % add p to archive and clean it
          Ax(end+1,:) = Px(i,:);
          Ay(end+1,:) = Py(i,:);
          [Ax,Ay] = nondom (Ax,Ay);
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
