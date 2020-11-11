% Funcion que compara el resultado con la frecuencua más cercana
function row = deteccion(locs,notas)
    resultado = abs(notas - locs(1)); % al vector de las notas se le resta el pico más alto de la fucnión
    if min(min(resultado)) <= 5 % si la resta es menor a 10 o igual
        [row,col] = find(resultado==min(min(resultado)));
    else
        row = length(notas)+1;
    end
end