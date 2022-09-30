clc, clear, close all
syms theta_1 theta_2 theta_3 theta_4 theta_5 theta_6 
a_1 = 0;                    alpha_1 = sym(-pi/2);       d_1 = (0.181);              theta_1 = -1.512;  %Joint_1:
a_2 = (0.613);              alpha_2 = 0;                d_2 = (0.176-0.137);        theta_2 = 0;  %Joint_2:
a_3 = (0.571);              alpha_3 = 0;                d_3 = 0;                    theta_3 = 0;  %Joint_3:
a_4 = 0;                    alpha_4 = sym(-pi/2);       d_4 = (0.135);              theta_4 = 0;  %Joint_4:
a_5 = 0;                    alpha_5 = sym(pi/2);        d_5 = (0.12);               theta_5 = -2.4; %Joint_5;
a_6 = 0;                    alpha_6 = 0;                d_6 = (0.16);               theta_6 = 0;  %Joint_6:

T_1 = transform_T(a_1,alpha_1,d_1,theta_1);
T_2 = transform_T(a_2,alpha_2,d_2,theta_2);
T_3 = transform_T(a_3,alpha_3,d_3,theta_3);
T_4 = transform_T(a_4,alpha_4,d_4,theta_4);
T_5 = transform_T(a_5,alpha_5,d_5,theta_5);
T_6 = transform_T(a_6,alpha_6,d_6,theta_6);
T_16 =  T_1 * T_2 * T_3 * T_4 * T_5 * T_6;
T_16;
% T_16(1,4) = 0.638;
% T_16(2,4) = -1.0515;
% T_16(3,4) = 0.06;
Px = (T_16(1,4));
Py = (T_16(2,4));
Pz = (T_16(3,4));
P_6 = double([Px,Py,Pz]);
theta1 = finding_theta_1(T_16,d_6);
theta5 = finding_theta_5(theta1,P_6,d_6);

% T = T_16(1:3,1:3);
% Rx = (atan2(T(3,2),T(3,3)));
% Ry = (atan2(-T(3,1),(T(3,2)^2 + T(3,3)^2)^0.5));
% Rz = (atan2(T(2,1),T(1,1)));
% R = [Rx,Ry,Rz];

%pose = [Px,Py,Pz,Rx,Ry,Rz];


function theta1 = finding_theta_1(T_16,d_6)
   Tranform_matrix = [0,0,-d_6,1]; %Transform matrix of P_6 to P_5
   Tranform_matrix = Tranform_matrix(:);
   T_15 = T_16*Tranform_matrix;
   P_5x = double(T_15(1,1));
   P_5y = double(T_15(2,1));
   P_5 = (P_5x^2 + P_5y^2)^0.5;
   alpha1 = atan2(P_5y,P_5x);
   alpha2 = asin(0.174/P_5);
   theta1 = (alpha1 - alpha2);
end

function theta5 = finding_theta_5(theta1,P_6,d_6)
    a = ( -P_6(1,1)*sin(theta1) + P_6(1,2)*cos(theta1) -0.174)/d_6
    if P_6(1,2)<0
        theta5 = acos(a);
    else
        theta5 = -acos(a);
    end
end

function T = transform_T(a,alpha,d,theta)
    T = [cos(theta) -sin(theta)*cos(alpha)  sin(theta)*sin(alpha) a*cos(theta); sin(theta) cos(theta)*cos(alpha) -cos(theta)*sin(alpha) a*sin(theta); 0 sin(alpha) cos(alpha) d; 0 0 0 1];
end
function R_x = transform_x_func(alpha)      %Function calc Yaw of Euler(Roll-Pitch-Yaw)
    R_x = [1 0 0 0;
           0 cos(alpha) -sin(alpha) 0;
           0 sin(alpha) cos(alpha) 0;
           0 0 0 1]
end
function R_z = transform_z_func(alpha)      %Function calc Pitch of Euler(Roll-Pitch-Yaw)
    R_z = [cos(alpha) -sin(alpha) 0 0;
           sin(alpha) cos(alpha) 0 0;
           0 0 1 0;
           0 0 0 1]
end
function R_y = transform_y_func(alpha)      %Function calc Roll of Euler(Roll-Pitch-Yaw)
    R_y = [cos(alpha) 0 sin(alpha) 0;
           0 1 0 0;
           -sin(alpha), 0, cos(alpha) 0
           0 0 0 1]
end
