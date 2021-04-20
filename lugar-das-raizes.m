pkg load control
%Definindo a fun�ao de transferencia da planta
Ngs = 1;
Dgs = [1 1 0 0];
Gps = tf(Ngs,Dgs);

%Definindo a fun��o de transferencia do sensor
Nhs = 1;
Dhs = 1;
Hs = tf(Nhs,Dhs);
GpHs = series(Gps,Hs)

%Especifica��es de overshoot e tempo de acomoda��o desejados
Mp = 0.3;
ts = 30;
zeta = sqrt((log(Mp))^2/((log(Mp))^2+pi^2))
wn = 4/(ts*zeta)

%Os polos pras especifica��es
s1 = -zeta*wn + i*wn*sqrt(1-zeta^2)
s2 = -zeta*wn - i*wn*sqrt(1-zeta^2)
figure

%LR do sistema nao compensado 
rlocus(GpHs)
hold

%Marca��o dos polos desejados no LR
%Verifica-se que os polos desejados n�o fazem parte do LR
plot(real(s1),imag(s1),'xm')
plot(real(s2),imag(s2),'xm')
hold

%Procedimento para o calculo de s0 e de K 
%para o controlador PD Gc(s) = K(s+s0)
GpHs1 = 1/(((s1)^2)*(s1+1));
ang_GpHs1 = angle(GpHs1)*180/pi
ang_Gcs1 = 180 - ang_GpHs1
theta_C0 = ang_Gcs1
s0 = 0.13333 + imag(s1)/tand(theta_C0)
mod_GpHs1 = abs(GpHs1);
r_C0 = abs(s1+s0);
K = 1/(r_C0*mod_GpHs1)

%Definindo a fun��o de transferencia do controlador PD
Ncs = K*[1 s0];
Dcs = 1;
Gcs = tf(Ncs,Dcs)

%Defininco G(s)
GcGpHs = series(Gcs,GpHs);
figure

%LR do sistema compensado
rlocus(GcGpHs)
hold

%Marca��o dos polos desejados no LR
%Nota-se que os polos desejados pertencem ao LR
plot(real(s1),imag(s1),'xm')
plot(real(s2),imag(s2),'xm')
hold
GcGps = series(Gcs,Gps)

%Malha fechada
Ts = feedback(GcGps,Hs)
figure

%Resposta do degrau em malha fechada
%Nota-se que o gr�fico n�o cruza o eixo imaginario a nao ser na origem
%Portanto o sistema em malha fechada � est�vel
step(Ts)
pole(Ts)

%R:--> o overshoot divergiu em rela��o a especifica��o, pois o sistema
%n�o � de 2a ordem padr�o, visto que h� 3 polos e 1 zero em malha fechada
%Assim, v�-se que o zero da malha fechada tem influencia na resposta ao degrau
%j� que seu efeito n�o � anulado por um polo, isto �, n�o h� polos na mesma posi��o
%Portanto as especifica��es resposta ao degrau divergem das esperadas