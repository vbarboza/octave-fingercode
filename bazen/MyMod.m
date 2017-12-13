function I = myMod(I)

r = rem(-1*I/pi,1);
q = -1*I/pi - r;
l = rem(q, 2);
I(I < -pi & l == 0) = 0 -r(I < -pi & l == 0);
I(I < -pi & l ~= 0) = pi -r(I < -pi & l ~= 0);
I(I > pi & l == 0) = 0 + r(I > pi & l == 0);
I(I > pi & l ~= 0) = -pi + r(I > pi & l ~= 0);

end