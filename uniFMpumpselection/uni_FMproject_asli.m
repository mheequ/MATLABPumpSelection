clc;clear all;close all;clearvars;
Q=input('Enter the desired flow rate of pump(m^3/h) 3-40:  ');
H=input('Enter the desired head of pump (m) 10-40:   '); fprintf('\n');
%% finding suitable pump
if match('Family_32_125',Q,H)
    disp('Family_32_125');
    fam='Family_32_125';
elseif match('Family_32_160',Q,H)
     disp('Family_32_160');
    fam='Family_32_160';
elseif match('Family_40_125',Q,H)
     disp('Family_40_125');
    fam='Family_40_125';
elseif match('Family_40_160',Q,H)
     disp('Family_40_160');
    fam='Family_40_160';
elseif match('Family_40_200',Q,H)
     disp('Family_40_200');
    fam='Family_40_200';
elseif match('Family_50_125',Q,H)
     disp('Family_50_125');
    fam='Family_50_125';
elseif match('Family_50_160',Q,H)
     disp('Family_50_160');
    fam='Family_50_160';
 elseif match('Family_50_200',Q,H)
     disp('Family_50_200');
    fam='Family_50_200';
else disp('Not in my considered range !!!!')
    return
end
%%  finding suitable diameter
data_qotr = xlsread(fam,'Diameter');
j=1;ff=0;
while ff==0
    if data_qotr(j,1)>=Q && data_qotr(j,2)>=H
        fprintf('suitable diameter: %.f (mm) \n',data_qotr(j,3));
        qotr=data_qotr(j,3);
       ff=1;
     end
     j=j+1;
end
%% finding pump efficiency
data_eff=xlsread(fam,'Efficiency');
data_Q=data_eff(:,1);
data_H=data_eff(:,2);
data_bazdeh=data_eff(:,3);

ggsh=scatteredInterpolant(data_Q,data_H,data_bazdeh,'natural','none');
bazdeh=ggsh(Q,H);
if isnan(bazdeh)
    fprintf('kamtar az 50%% !!!!\n');
else
fprintf('efficiency: %2.2f %% \n',bazdeh);
end
[Q_grid,H_grid] = meshgrid(linspace(min(data_Q),max(data_Q),100),linspace(min(data_H),max(data_H),100));
Eta_grid = ggsh(Q_grid,H_grid);
%efficiency plot
subplot(1,2,1)
contourf(Q_grid,H_grid,Eta_grid,10,'LineColor','none'); 
hold on
plot(Q,H,'ro','MarkerFaceColor','r'); 
plot(Q,H,'ks','MarkerSize',8,'MarkerFaceColor','k') ;
xlabel('Q (m^3/h)'); ylabel('H (m)');
title('2D Efficiency Map (Q-H)');
colorbar; colormap jet ;grid on; axis tight;
%% finding corresponding power
data_power=xlsread(fam,'Power');
adrs=data_power(:,3)==qotr;
my_power=data_power(adrs,[1 2]);
pwr_man=interp1(my_power(:,1),my_power(:,2),Q,'spline');
fprintf('power: %5.5f (kW) \n',pwr_man);
%power plot
subplot(1,2,2)
plot(my_power(:,1),my_power(:,2),'.r') 
hold on
plot(Q,pwr_man,'*g')
xlabel('Q (m^3/h)'); ylabel('power (kW)'); title('power Map (Q-power)'); grid on; axis tight;