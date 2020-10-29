% Angie Camila Ojeda Rojas, 8 Octubre de 2020
% Primer laboratorio DSP
% Editor de archuvos de audio

function varargout = editor_de_archivos_audio(varargin)
% EDITOR_DE_ARCHIVOS_AUDIO MATLAB code for editor_de_archivos_audio.fig
%      EDITOR_DE_ARCHIVOS_AUDIO, by itself, creates a new EDITOR_DE_ARCHIVOS_AUDIO or raises the existing
%      singleton*.
%
%      H = EDITOR_DE_ARCHIVOS_AUDIO returns the handle to a new EDITOR_DE_ARCHIVOS_AUDIO or the handle to
%      the existing singleton*.
%
%      EDITOR_DE_ARCHIVOS_AUDIO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITOR_DE_ARCHIVOS_AUDIO.M with the given input arguments.
%
%      EDITOR_DE_ARCHIVOS_AUDIO('Property','Value',...) creates a new EDITOR_DE_ARCHIVOS_AUDIO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before editor_de_archivos_audio_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to editor_de_archivos_audio_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help editor_de_archivos_audio

% Last Modified by GUIDE v2.5 15-Oct-2020 21:20:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @editor_de_archivos_audio_OpeningFcn, ...
                   'gui_OutputFcn',  @editor_de_archivos_audio_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before editor_de_archivos_audio is made visible.
function editor_de_archivos_audio_OpeningFcn(hObject, eventdata, handles, varargin)

global contador

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to editor_de_archivos_audio (see VARARGIN)

% Choose default command line output for editor_de_archivos_audio
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
contador = 0;

% UIWAIT makes editor_de_archivos_audio wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = editor_de_archivos_audio_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function grabar_Callback(hObject, eventdata, handles)

global fs senal

info = inputdlg({'Frecuencia de muestreo','Tiempo de grabaci�n'},'Datos de grabaci�n',1);
fs = str2double(info(1));
tiempo = str2double(info(2));
nbits = 16;
nchannels = 1; % numero de microfonos
id = -1; % canal de salida, estandar
recobj = audiorecorder(fs,nbits,nchannels,id) % parametroa de audio
disp('Start speaking.') % empezar a grabar
recordblocking(recobj,tiempo); % tiempo de grabaci�n
disp('end of recording.') % fin de grabarci�n
senal = getaudiodata(recobj);
t = (0:length(senal)-1)/fs;
axes(handles.axes1);
plot(t,senal,'-','Color','g','LineWidth',1)

function reproducir_Callback(hObject, eventdata, handles)

global fs senal

sound(senal, fs) % reproducir audio

function reproducir_respuesta_Callback(hObject, eventdata, handles)

global fs senal_total

sound(senal_total, fs)

function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function cortar_Callback(hObject, eventdata, handles)

global fs senal contador senal_total

if contador == 1
    [x,y] = ginput(2)
    bandera = 0;
    x1 = round(x(1)*fs);
    x2 = round(x(2)*fs);
    if x2 < x1
        r = x2;
        x2 = x1;
        x1 = r;
    end
    senal_cortada = senal(x1:x2);
    [x,y] = ginput(1);
    if x < 0
        x = 1;
    end
    x1 = round(x*fs)
    if x1 > length(senal_total)
        x1 = length(senal_total);
    end
    if length(senal_cortada) > length(senal_total(x1:end)) && bandera == 0
        senal_total = senal_total(1:x1);
        senal_total = [senal_total;senal_cortada];
        bandera = 1;
    end
    if length(senal_cortada) < length(senal_total(x1:end)) && bandera == 0
        senal_reemplazo = senal_total;
        senal_total = senal_total(1:x1);
        senal_total = [senal_total;senal_cortada];
        senal_reemplazo = senal_reemplazo(length(senal_total):end);
        senal_total = [senal_total;senal_reemplazo];
        bandera = 1;
    end
    t = (0:length(senal_total)-1)/fs;
    axes(handles.axes2);
    plot(t,senal_total,'-','Color','r','LineWidth',1)
end

if contador == 0
    [x,y] = ginput(2)
    x1 = round(x(1)*fs);
    x2 = round(x(2)*fs);
    if x2 < x1
        r = x2;
        x2 = x1;
        x1 = r;
    end
    if x2 > length(senal)
        x2 = length(senal);
    end
    if x1/fs < 0
        x1 = 1;
        x1 = x1*fs;
    end

    senal_resultado = senal(x1:x2);
    contador = 1;
    senal_total = senal_resultado;
    t = (0:length(senal_total)-1)/fs;
    axes(handles.axes2);
    plot(t,senal_total,'-','Color','r','LineWidth',1)
end

function mezclar_Callback(hObject, eventdata, handles)

global fs senal_total senal

[x,y] = ginput(2)
x1 = round(x(1)*fs);
x2 = round(x(2)*fs);
if x2 < x1
    r = x2;
    x2 = x1;
    x1 = r;
end
senal_cortada = senal(x1:x2);
senal_reemplazo = senal_total;
[x,y] = ginput(1)
if x < 0
    x = 1;
end
x1 = round(x*fs);
bandera = 0;
if x1 > length(senal_total)
    x1 = length(senal_total);
end
if length(senal_cortada) < length(senal_total(x1:end)) && bandera == 0
    senal_total = senal_total(1:x1);
    senal_reemplazo = senal_reemplazo(x1:end);
    x = length(senal_reemplazo) - length(senal_cortada);
    senal_cortada = [senal_cortada' zeros(1,x)]';
    senal_reemplazo = senal_reemplazo + senal_cortada;
    senal_total = [senal_total;senal_reemplazo];
    bandera = 1;
end
if length(senal_cortada) > length(senal_total(x1:end)) && bandera == 0
    senal_total = senal_total(1:x1);
    senal_reemplazo = senal_reemplazo(x1:end);
    x = length(senal_cortada) - length(senal_reemplazo);
    senal_reemplazo =  [senal_reemplazo' zeros(1,x)]';
    senal_reemplazo = senal_reemplazo + senal_cortada;
    senal_total = [senal_total;senal_reemplazo];
    bandera = 1;
end
t = (0:length(senal_total)-1)/fs;
axes(handles.axes2);
plot(t,senal_total,'-','Color','r','LineWidth',1)

function insertar_Callback(hObject, eventdata, handles)

global fs senal_total senal

[x,y] = ginput(2)
x1 = round(x(1)*fs);
x2 = round(x(2)*fs);
if x2 < x1
    r = x2;
    x2 = x1;
    x1 = r;
end
senal_cortada = senal(x1:x2);
senal_reemplazo = senal_total;
[x,y] = ginput(1)
if x < 0
    x = 1;
end
x1 = round(x*fs);
if x1 > length(senal_total)
    x1 = length(senal_total);
end
senal_total = senal_total(1:x1);
senal_reemplazo = senal_reemplazo(x1:end);
senal_total = [senal_total;senal_cortada;senal_reemplazo];
t = (0:length(senal_total)-1)/fs;
axes(handles.axes2);
plot(t,senal_total,'-','Color','r','LineWidth',1)

function invertir_Callback(hObject, eventdata, handles)

global fs senal_total

[x,y] = ginput(2)
x1 = round(x(1)*fs);
x2 = round(x(2)*fs);
if x2 < x1
    r = x2;
    x2 = x1;
    x1 = r;
end
if x2 > length(senal_total)
    x2 = length(senal_total);
end
senal_cortada = senal_total(x1:x2);
senal_reemplazo = senal_total;
senal_inversa = senal_cortada';
senal_inversa = fliplr(senal_inversa);
senal_inversa = senal_inversa';
senal_total = senal_total(1:x1);
senal_reemplazo = senal_reemplazo(x2:end)
senal_total = [senal_total;senal_inversa;senal_reemplazo];

t = (0:length(senal_total)-1)/fs;
axes(handles.axes2);
plot(t,senal_total,'-','Color','r','LineWidth',1)

function amplificar_Callback(hObject, eventdata, handles)

global fs senal_total

info = inputdlg({'Valor de amplificaci�n'},'Amplificaci�n de la se�al',1);
amp = str2double(info(1));

[x,y] = ginput(2)
x1 = round(x(1)*fs);
x2 = round(x(2)*fs);
if x2 < x1
    r = x2;
    x2 = x1;
    x1 = r;
end
if x2 > length(senal_total)
    x2 = length(senal_total);
end
senal_cortada = senal_total(x1:x2);
senal_reemplazo = senal_total;
senal_total = senal_total(1:x1);
senal_reemplazo = senal_reemplazo(x2:end)
senal_total = [senal_total;senal_cortada*amp;senal_reemplazo];

t = (0:length(senal_total)-1)/fs;
axes(handles.axes2);
plot(t,senal_total,'-','Color','r','LineWidth',1)

function grabar_2_Callback(hObject, eventdata, handles)

global fs senal

info = inputdlg({'Frecuencia de muestreo','Tiempo de grabaci�n'},'Datos de grabaci�n',1);
fs = str2double(info(1));
tiempo = str2double(info(2));
nbits = 16;
nchannels = 1; % numero de microfonos
id = -1; % canal de salida, estandar
recobj = audiorecorder(fs,nbits,nchannels,id) % parametroa de audio
disp('Start speaking.') % empezar a grabar
recordblocking(recobj,tiempo); % tiempo de grabaci�n
disp('end of recording.') % fin de grabarci�n
senal = getaudiodata(recobj);
t = (0:length(senal)-1)/fs;
axes(handles.axes1);
plot(t,senal,'-','Color','g','LineWidth',1)

function importar_Callback(hObject, eventdata, handles)

global senal fs

[filename, pathname] = uigetfile('*.wav', 'Seleccione el audio para editar');
filename = join([pathname, filename]);
[y,fs] = audioread(filename);
senal = y;

senal = senal(:,1);

t = (0:length(senal)-1)/fs;
axes(handles.axes1);
plot(t,senal,'-','Color','g','LineWidth',1)

function exportar_Callback(hObject, eventdata, handles)

global senal senal_total fs

list = {'Audio Original','Audio Resultado'};
opcion = listdlg('PromptString',{'Seleccionar el archivo que desea guardar.'},'SelectionMode','single','ListString',list);

if opcion == 1
    [file,path,indx] = uiputfile('*.wav', 'Guardar como');
    path = join([path, file]);
    audiowrite(path,senal,fs,'BitsPerSample',16);
end

if opcion == 2
    [file,path,indx] = uiputfile('*.wav', 'Guardar como');
    path = join([path, file]);
    audiowrite(path,senal_total,fs,'BitsPerSample',16);
end

function detener_Callback(hObject, eventdata, handles)

clear sound;

function detener_1_Callback(hObject, eventdata, handles)

clear sound;

function Borrar_respuesta_Callback(hObject, eventdata, handles)

global contador

opc=questdlg('Los datos no porfr�n ser recuperados, �seguro que desea borrarlos?','Borrar audio resultado','Si','No','No');
if strcmp(opc,'No')
    return; 
end
if strcmp(opc,'Si')
    contador = 0;
    cla(handles.axes2,'reset');
end

function borrar_Callback(hObject, eventdata, handles)

opc=questdlg('Los datos no porfr�n ser recuperados, �seguro que desea borrarlos?','Borrar grabaci�n original','Si','No','No');
if strcmp(opc,'No')
    return; 
end
if strcmp(opc,'Si')
    cla(handles.axes1,'reset');
end