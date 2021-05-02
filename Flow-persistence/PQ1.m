clc
clear
cd('D:\Geomar\2-MODULES\2.1-PROGRAMMING\2.1.3-MATLAB\Persistencia-caudales');
file = 'molde-PQ.xlsx';
sheet = 'Hoja1';
[ data, encabezado, both] = xlsread( file, sheet);

[ f, c] = size(data);
est = zeros( length(data)/12, 12, c);

for i = 1:c
nd = reshape( data(:,i), [ 12, length(data)/12])';
est( :, :, i) = nd; 
end

prom = zeros( c, 12);
maxv = zeros( c, 12);
minv = zeros( c, 12);

for j = 1:c
    for i = 1:12
        prom(j,i) = mean(est( :, i, j));
        maxv(j,i) = max(est( :, i, j));
        minv(j,i) = min(est( :, i, j));
    end
end

prc = zeros( 3, 12, c);
prc1 = prctile(est( :, 1, 1),[50 75 95],1);

for j = 1:c
    for i = 1:12
    prc( :, i, j) = prctile(est( :, i, j),[50 25 5],1);
    end
end

mes = ['ene'; 'feb'; 'Mar'; 'Abr'; 'May'; 'Jun';'Jul';'Ago'; 'Sep'; 'Oct'; 'Nov'; 'Dic'];

for i = 1:3
fig1 = figure();
plot(smooth(prc( 1, :, i)),'LineWidth', 2);
hold on
plot(smooth(prc( 2, :, i)),'LineWidth', 2);
plot(smooth(prc( 3, :, i)),'LineWidth', 2);
xlim([0 13]);
ylim([0 max(prc( 1, :, i))*1.05]);
title(['Persistencia de Caudales (m³/s) - Subcuenca ' encabezado{1,i+1}]);
ylabel('Caudales (m³/s)');
set(gca,'Xtick',1:12,'xticklabel',mes);
title_prc = {'50%','75%','95%'};
legend (title_prc, 'Location', 'southoutside','Orientation','horizontal');
set(gcf,'Visible','off')
filefig = strcat('JPG/',num2str(i),'_',encabezado{1,i+1},'.jpg');
print(gcf,filefig,'-djpeg','-r1000');
end

path = 'persistencia_caudales.xlsx';
mes_txt = {'ene', 'feb', 'Mar', 'Abr', 'May', 'Jun','Jul','Ago', 'Sep', 'Oct', 'Nov', 'Dic'};

 for k = 1:c
     sheet = strcat(num2str(k),'_',encabezado{1,k+1});
     xlRange1 = "A1:L1";
     xlRange2 = "A2:L59";
     xlRange3 = "A63:L63";
     xlRange4 = "A64:L66";
       
     m1_xlsx = xlswrite(path, mes_txt, sheet, xlRange1);
     Q_xlsx = xlswrite(path, ...
         vertcat(est( :, :, k), prom(k,:), maxv(k,:), minv(k,:)), sheet, xlRange2);
     
     m2_xlsx = xlswrite(path, mes_txt, sheet, xlRange3);
     PQ_xlsx = xlswrite(path, prc(:,:,k), sheet, xlRange4);
     
     warning('off','all')
 end
warning('off','all')