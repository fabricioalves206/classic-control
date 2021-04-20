pkg load control
Ngs = 1;
Dgs = [1 1];
Gps = tf(Ngs,Dgs);
Nhs = 1;
Dhs = 1;
Hs = tf(Nhs,Dhs);
HGs = series(Gps,Hs);
T = 0.05;
Mp = 0.2;
ts = 0.8;
Gz = c2d(Gps,T,'zoh');
HGz = c2d(HGs,T,'zoh')
zeta = sqrt((log(Mp))^2/((log(Mp))^2+pi^2));
wn = 4/(ts*zeta);
s1 = -zeta*wn+i*wn*sqrt(1-zeta^2);
z1 = exp(s1*T)
HGz1 = (0.04877)/(z1-0.9512); 
ang_HGz1 = angle(HGz1)*180/pi
ang_Dz1 = -180 - ang_HGz1
zp = 1;
theta_Dp = angle(z1-zp)*180/pi
theta_D0 = theta_Dp + ang_Dz1
z0 = abs(real(z1)) + imag(z1)/tand(theta_D0)
mod_HGz1 = abs(HGz1)
Kd = abs(z1-zp)/(abs(z1-z0)*mod_HGz1)
Ndz = Kd*[1 -z0];
Ddz = [1 -zp];
Dz = tf(Ndz,Ddz,T)
HGDz = series(Dz,HGz);
Tz = (Gz*Dz)/(1+HGDz);
[num_ec,den_ec] = tfdata(1+HGDz,'v');
polos_mf = roots(num_ec)
figure
step(Tz)

%R:Observamos que os requisitos de overshoot de 20% e tempo de acomodação
%de 0,8 segundos foram atendidos