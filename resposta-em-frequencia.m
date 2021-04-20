pkg load control
Ngps = [0.5 10];
Dgps = [1 20 100];
Gps = tf(Ngps,Dgps)
Nhs = 10;
Dhs = [0.01 1];
Hs = tf(Nhs,Dhs)
GpHs = series(Gps,Hs)
Ts = feedback(GpHs,Hs);
figure
margin(GpHs)
Mp = 0.15;
ts = 0.1;
zeta = sqrt((log(Mp))^2/((log(Mp))^2+pi^2))
phim = atand(2*zeta/sqrt(sqrt(4*zeta^4+1)-2*zeta^2))
wu = 8/(ts*tand(phim))
[mag_GpHwu,phase_GpHwu] = bode(GpHs,wu)
phase_Gcwu = -180+phim-phase_GpHwu

sp = 0
phase_Cp = 90
s0 = 0.1*wu
phase_C0 = angle(i*wu + s0)*180/pi
phase_C02 = phase_Cp - phase_C0 + phase_Gcwu
s02 = wu/(tand(phase_C02))
rC0 = abs(i*wu+s0);
rCp = abs(i*wu+sp);
rC02 = abs(i*wu+s02);
K = rCp/(rC0*rC02*mag_GpHwu)

Ngcs = K*[1 s0+s02 s0*s02];
Dgcs = [1 sp];
Gcs = tf(Ngcs,Dgcs)
GcGps = series(Gcs,Gps);
GcGpHs = series(Gcs,GpHs);
Ts = feedback(GcGps,Hs);
figure
margin(GcGpHs)

figure
step(Ts)

%phim =  53.172º
%wu =  59.909 rad/s
%foram testados os 3 diferentes valores para s0:
%O requisitos do sistema foram atendidos para s0 = 10*wu, tendo
%um overshoot de 12,5% e tempo de acomodação de 0,1s. Entretando para
%s0 = 0,1*wu, o sistema se tornou instável, pois para que o angulo
%do controlador fosse atendido, seria necessário um zero no SPD.
%Para s0 = wu, o tempo de acomodação não foi atentido, pois o efeito
%do zero é acentuado.