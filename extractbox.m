function [exno,exelem] = extractbox(node,elem,xlim,ylim,zlim,type)
% extract a smaller 3D box from a larger mesh or face
% input:
%     node: node list of the triangular surface, 3 columns for x/y/z
%     elem: element/surface list of the tetrahedral mesh (see type)
%     xlim,ylim,zlim: lower and upper bound of the extracted 3D box with form [low,high]
%     type: 'element': 2nd input ele is element
%           'face': 2nd input ele is face
% output:
%     exno: node for extracted surface
%     exelem: face for extracted surface
% example:
%     [node,face,elem]=meshabox([0 0 0],[100 100 100],500,50);
%     % extract element
%     [exnoe,exelem] = extractbox(node,elem,[0 100],[0 100],[10 50],'element');
%     figure,plotmesh(exnoe,exelem)
%     % extract face
%     [exnof,exface] = extractbox(node,face,[0 100],[0 100],[10 50],'face');
%     figure,plotmesh(exnof,exface)
% -- this function is part of iso2mesh toolbox (http://iso2mesh.sf.net)
% 

% get the index of nodes inside the box
tx = node(:,1)>=xlim(1) & node(:,1)<=xlim(2);
ty = node(:,2)>=ylim(1) & node(:,2)<=ylim(2);
tz = node(:,3)>=zlim(1) & node(:,3)<=zlim(2);
t = (tx & ty) & tz;
ind = find(t==1);

% 1: belongs to extracted region
% 0: does not belong to extracted region
flogic = ismember(elem,ind);

% all nodes of element/face should belong to the extracted region
if strcmp(type,'element')
    flogic = sum(flogic(:,1:4),2);  % element
    flogic = flogic==4;
elseif strcmp(type,'face')
    flogic = sum(flogic(:,1:3),2);  % face
    flogic = flogic==3;
else
    error('Error. type must be either element or face') 
end

exelem = elem(flogic,:);
[exno,exelem] = removeisolatednode(node,exelem);

end

