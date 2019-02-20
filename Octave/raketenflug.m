%Keine Ahnung, ob das für Windows funktioniert
graphics_toolkit('gnuplot')


%Größte erreichte Flughöhe
s_max = -1;

%Parameter für die Berechnung
A = 0.0014486 %m^2
F_Schub = 6 %N
m = 0.12 %kg
rho = 1.2 %kg/m^3
g = 9.81 %s/m^2

%Die gemessenen C_w-Werte
C_w = 0.201805961 %konisch
%C_w = 0.186535648 %ellipsoid
%C_w = 0.170981811 %ogiv
%C_w = 0.189116315 %Haack
%C_w = 0.268958542 %experimentell


%Zeitvektor mit Schrittweite delta
delta = 0.001
t = 0:delta:15;

%Geschwindigkeitsvektor mit gleichvielen Elementen wie t
v = 0:1:(t(end)/delta);
s = 0:1:(t(end)/delta);
a = 0:1:(t(end)/delta);
%v = zeros(1,t(end)/delta);

%Korrekturfaktor, um das Vorzeichen vom Luftwiederatnd zu ändern
k = 1;

%Berechnung der Geschwindigkeit u.ä.
n = 1;
while(t(n) < t(end))
v(n+1) = delta * (F_Schub/m -g -A*C_w*rho*v(n)^2/(m*2)*k) + v(n);
a(n+1) = (v(n+1)-v(n)) /delta;
s(n+1) = v(n+1) *delta + s(n);

%Setze Schubkraft auf null
if(t(n+1) >= 1.6)
F_Schub = 0;
endif

%Anpassung des Luftwiderstandes
if(v(n+1) < 0)
k = -1;
endif

%Maximale Flughöhe
if(v(n+1) < 0 && v(n) > 0)
s_max = s(n)
endif

n++;
endwhile

%Mogelei, um den ersten Wert für a anzupassen.
a(1)=a(2);

%Plotten
h=figure
subplot(1,3,1)
plot(t,s,'b','LineWidth',2)
%title("t-s-Diagramm", 'left',)
xlabel("t [s]")
ylabel("s [m]")
xlim([0 12])
grid on

subplot(1,3,2)
plot(t,v,'g','LineWidth',2)
%title("t-v-Diagramm", 'left')
xlabel("t [s]")
ylabel("v [m/s]")
xlim([0 12])
grid on

subplot(1,3,3)
plot(t,a,'r','LineWidth',2)
%title("t-a-Diagramm", 'left')
xlabel("t [s]")
ylabel("a [m/s^2]")
xlim([0 12])
grid on

set(h,'PaperUnits','inches')
set(h,'PaperOrientation','portrait');
set(h,'PaperSize',[10/2.5,17.8/2.5])
set(h,'PaperPosition',[0,0,17.8/2.5,10/2.5])
%print -dpng -r300 plot.png
print(h,'-dpng','-r500','plot.png')