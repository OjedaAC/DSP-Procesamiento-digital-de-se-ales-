function varargout = identificador_de_notas(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @identificador_de_notas_OpeningFcn, ...
                   'gui_OutputFcn',  @identificador_de_notas_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function identificador_de_notas_OpeningFcn(hObject, eventdata, handles, varargin)

global b n notas

handles.output = hObject;

guidata(hObject, handles);

b = 0;
n = ["Do","Do#","Re","Re#","Mi","Fa","Fa#","Sol","Sol#","La","La#","Si",""];
dominantes = [32.7, 34.65, 36.71, 38.89, 41.2, 43.65, 46.25, 49, 51.91, 55, 58.27, 61.74];

for f = 1:12
    for c = 1:7
        notas(f,c) = dominantes(f)*(2^(c-1));
        if c == 1
            notas(f,c) = dominantes(f);      
        end
    end
end

function varargout = identificador_de_notas_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function stop_Callback(hObject, eventdata, handles)
global b
b = 1;

function start_Callback(hObject, eventdata, handles)

global b n notas
b = 0;
while (b == 0)    
    fs = 8000; % frecuencia de muestreo
    tiempo = 0.2;
    nbits = 16;
    nchannels = 1; % numero de microfonos
    id = -1; % canal de salida, estandar
    recobj = audiorecorder(fs,nbits,nchannels,id); % parametroa de audio
    
    recordblocking(recobj,tiempo); % tiempo de grabación
    senal = getaudiodata(recobj);
    
    y=fft(senal);
    l = length(senal);
    P2 = abs(y/l);
    P1 = P2(1:l/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = fs*(0:(l/2))/l;
    plot(f,P1)
    title('Single-Sided Amplitude Spectrum of X(t)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
    [pks,locs,w,p] = findpeaks(P1,f,'MinPeakDistance',100,'MinPeakProminence',max(P1)/2);
    
    if max(P1)/2 < 0.001
        locs(1) = 1;
    end
    row = deteccion(locs,notas);
    set(handles.nota,'String',n(row));
end