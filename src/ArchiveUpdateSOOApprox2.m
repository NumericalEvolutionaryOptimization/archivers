% ArchiveUpdateSOOApprox2
%
% Input Parameters: 
% Ax0, Ay0: given archive
% xbest, ybest: best found solution
% Px, Py:   candidate set
% eps:      discretization parameter in image space
% Delta:    discretization parameter in param space
%
% Output Parameters:
% xbest, ybest: best found solution
% Ax, Ay: archive containing epsilon-approximate solutions

function[xbest,ybest,Ax,Ay] = ArchiveUpdateSOOApprox2 (Ax0, Ay0, xbest, ybest, Px, Py, eps, Delta)

   Ax = Ax0; 
   Ay = Ay0;
   
   nA = length (Ay(:,1));
   nP = length (Py(:,1));
   
   for i = 1:nP,
       if Py(i)<ybest,
           xbest = Px(i,:);
           ybest = Py(i);
       end
       %check if-condition
       discard = 0;
       if  ybest+eps < Py(i,:), % alternatively Ay(i,:) instead of ybest
          discard = 1;
          break;
       end
       for j=1:nA,
         if  is_in_box(Px(i,:),Ax(j,:),Delta)==1 & Py(i)>Ay(j),
             discard = 1;
             break;
         end
       end
       
       % p is not -eps-dominated by A
       if discard == 0,
          % step 1:  discard -eps-dominated solutions
          index = []; 
          for j = 1:nA,
              if Py(i,:)+eps > Ay(j,:),
                   index(end+1) = j;
              end    
          end    
          Ax = Ax(index,:);
          Ay = Ay(index,:);
          nA = length (Ay(:,1));   
          % step 2: discard dominated solutions in neighborhood
          index = [];
          for j = 1:nA,
            if is_in_box(Px(i,:),Ax(j,:),Delta)==0 | Py(i)>Ay(j),
                index(end+1) = j;
            end
          end
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
