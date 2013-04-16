function []=plotsphere_tot(g,dir,siz,col)

%figure;

view_elev = 30
view_azi = [-60 -30 30 60 ]

for viewno = 1:4
    subplot(3,5,(10+viewno))
    
    [x,y,z] = sphere(100);
    s = surf(x,y,z);
    set(s, 'FaceColor', [1  0  0], 'EdgeColor', 'none');light
    lighting gouraud
    alpha(0.6)
    hold on
    plot3 (g(:,1),g(:,2),g(:,3),'o','MarkerFaceColor',col,'MarkerSize',siz)
    
    plot3(1.3*[dir(1) -dir(1)],1.3*[dir(2) -dir(2)],1.3*[dir(3) -dir(3)],'--b','LineWidth',3)

    view([view_azi(viewno) view_elev])
    
    xlabel('PHASE');
    ylabel('READ');
    zlabel('SLICE');
    
    axis equal;
    

end
