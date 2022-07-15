% ArchiveUpdateP_QepsS with Spread
function[Ax,Ay] = ArchiveUpdateP_Qeps(Ax0, Ay0, Px, Py, eps, Delta)

   Ax = Ax0; 
   Ay = Ay0;
   
   nA = size(Ay0,1);
   nP = size(Py,1);
   
   for i = 1:nP,
       discard = 0;
       for j=1:nA,
         if dominance(Ay(j,:)+eps,Py(i,:)),
             discard = 1; %point already eps-dominated
             break;
         end
       end  
       if discard == 0,
          for j = 1:nA, 
            if is_in_box(Px(i,:),Ax(j,:),Delta)==1,
                Aj = [Ax(1:j-1,:);Ax(j+1:end,:)];
                dj = dist(Ax(j,:),Aj);
                di = dist(Px(i,:), Ax);
                if di < dj,
                   Ax = [Aj;Px(i,:)];
                   Ay = [Ay(1:j-1,:);Ay(j+1:end,:);Py(i,:)];
                else
                   discard = 1; 
                   break; 
                end
            end    
          end 
          
          if discard == 0,
             index = []; 
             for j = 1:nA,
                 if dominance(Py(i,:)+eps+Delta,Ay(j,:))==0,
                      index(end+1) = j;
                 end    
             end    
             index;
             Ax = [Ax(index,:);Px(i,:)];
             Ay = [Ay(index,:);Py(i,:)];
             nA = length (Ay(:,1));
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

function d = dist(b,A)
  n = length(A(:,1));
  m = norm(b - A(1,:),2);
  for i = 2:n,
      m = min(m,norm(b - A(i,:),2));
  end    
  d = m;
  
  