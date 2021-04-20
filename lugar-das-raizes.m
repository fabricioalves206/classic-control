pkg load control
%Definindo a funçao de transferencia da planta
Ngs = 1;
Dgs = [1 1 0 0];
Gps = tf(Ngs,Dgs);

%Definindo a função de transferencia do sensor
Nhs = 1;
Dhs = 1;
Hs = tf(Nhs,Dhs);
GpHs = series(Gps,Hs)

%Especificações de overshoot e tempo de acomodação desejados
Mp = 0.3;
ts = 30;
zeta = sqrt((log(Mp))^2/((log(Mp))^2+pi^2))
wn = 4/(ts*zeta)

%Os polos pras especificações
s1 = -zeta*wn + i*wn*sqrt(1-zeta^2)
s2 = -zeta*wn - i*wn*sqrt(1-zeta^2)
figure

%LR do sistema nao compensado 
rlocus(GpHs)
hold

%Marcação dos polos desejados no LR
%Verifica-se que os polos desejados não fazem parte do LR
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

%Definindo a função de transferencia do controlador PD
Ncs = K*[1 s0];
Dcs = 1;
Gcs = tf(Ncs,Dcs)

%Defininco G(s)
GcGpHs = series(Gcs,GpHs);
figure

%LR do sistema compensado
rlocus(GcGpHs)
hold

%Marcação dos polos desejados no LR
%Nota-se que os polos desejados pertencem ao LR
plot(real(s1),imag(s1),'xm')
plot(real(s2),imag(s2),'xm')
hold
GcGps = series(Gcs,Gps)

%Malha fechada
Ts = feedback(GcGps,Hs)
figure

%Resposta do degrau em malha fechada
%Nota-se que o gráfico não cruza o eixo imaginario a nao ser na origem
%Portanto o sistema em malha fechada é estável
step(Ts)
pole(Ts)

%R:--> o overshoot divergiu em relação a especificação, pois o sistema
%não é de 2a ordem padrão, visto que há 3 polos e 1 zero em malha fechada
%Assim, vê-se que o zero da malha fechada tem influencia na resposta ao degrau
%já que seu efeito não é anulado por um polo, isto é, não há polos na mesma posição
%Portanto as especificações resposta ao degrau divergem das esperadas