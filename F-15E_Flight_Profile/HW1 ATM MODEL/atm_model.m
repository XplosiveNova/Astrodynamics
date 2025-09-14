function [z, temp, pressure, rho] = atm_model(altitude, units)

format long

if units == "EN"
    gc_1 = 0.3048;          % [FT]
    gc_2 = 1.8;             % [R]
    gc_3 = 0.020885;        % [psf]
    gc_4 = 0.0019403203;    % [slug/ft3]
else
    gc_1 = 1;
    gc_2 = 1;
    gc_3 = 1;
    gc_4 = 1;
end

altitude = altitude * gc_1;

z = 6356766 * altitude / (6356766 + altitude);

R = 287.0528;
g = 9.806645;

t0 = 288.15;
t1 = 216.65;
t2 = 216.65;
t3 = 228.65;
t4 = 270.65;
t5 = 270.65;
t6 = 252.65;
t7 = 180.65;

p0 = 101325;
p1 = p0 * (t1/t0) ^ (-g/(R*-6.5/1000));
p2 = p1 * exp(-g * (20000-11000) / (R*t1));
p3 = p2 * (t3/t2) ^ (-g/(R*1/1000));
p4 = p3 * (t4/t3) ^ (-g/(R*2.8/1000));
p5 = p4 * exp(-g * (52000-47000) / (R*t4));
p6 = p5 * (t6/t5) ^ (-g/(R*-2/1000));
p7 = p6 * (t7/t6) ^ (-g/(R*-4/1000));

if z < 0
    temp = t0;
    pressure = p0;
    rho = pressure/(R*temp);

elseif (0 <= z) && (z <= 11000)
    t_i = t0;
    tg_i = -6.5/1000;
    temp = t_i + tg_i * (z);
    pressure = p0 * (temp/t_i) ^ (-g/(R*tg_i));
    rho = pressure/(R*temp);

elseif (11000 < z) && (z <= 20000)
    t_i = t1;
    tg_i = 0;
    temp = t_i + tg_i * (z-11000);
    pressure = p1 * exp(-g * (z-11000) / (R*t_i));
    rho = pressure/(R*temp);
    
elseif (20000 < z) && (z <= 32000)
    t_i = t2;
    tg_i = 1/1000;
    temp = t_i + tg_i * (z-20000);
    pressure = p2 * (temp/t_i) ^ (-g/(R*tg_i));
    rho = pressure/(R*temp);

elseif (32000 < z) && (z <= 47000)
    t_i = t3;
    tg_i = 2.8/1000;
    temp = t_i + tg_i * (z-32000);
    pressure = p3 * (temp/t_i) ^ (-g/(R*tg_i));
    rho = pressure/(R*temp);

elseif (47000 < z) && (z <= 52000)
    t_i = t4;
    tg_i = 0;
    temp = t_i + tg_i * (z-47000);
    pressure = p4 * exp(-g * (z-47000) / (R*t_i));
    rho = pressure/(R*temp);

elseif (52000 < z) && (z <= 61000)
    t_i = t5;
    tg_i = -2/1000;
    temp = t_i + tg_i * (z-52000);
    pressure = p5 * (temp/t_i) ^ (-g/(R*tg_i));
    rho = pressure/(R*temp);

elseif (61000 < z) && (z <= 79000)
    t_i = t6;
    tg_i = -4/1000;
    temp = t_i + tg_i * (z-61000);
    pressure = p6 * (temp/t_i) ^ (-g/(R*tg_i));
    rho = pressure/(R*temp);

elseif (79000 < z) && (z <= 90000)
    t_i = t7;
    tg_i = 0;
    temp = t_i + tg_i * (z-79000);
    pressure = p7 * exp(-g * (z-79000)/(R*t_i));
    rho = pressure/(R*temp);

end

if units == "EN"
    z = z * gc_1;
    temp = temp * gc_2;
    pressure = pressure * gc_3;
    rho = rho * gc_4;
end

end