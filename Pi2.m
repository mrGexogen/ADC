function varargout = Pi2(varargin)
% PI2 MATLAB code for Pi2.fig
%      PI2, by itself, creates a new PI2 or raises the existing
%      singleton*.
%
%      H = PI2 returns the handle to a new PI2 or the handle to
%      the existing singleton*.
%
%      PI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PI2.M with the given input arguments.
%
%      PI2('Property','Value',...) creates a new PI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pi2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pi2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pi2

% Last Modified by GUIDE v2.5 30-Sep-2015 11:34:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pi2_OpeningFcn, ...
                   'gui_OutputFcn',  @Pi2_OutputFcn, ...
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


% --- Executes just before Pi2 is made visible.
function Pi2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pi2 (see VARARGIN)

% Choose default command line output for Pi2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Pi2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_load.
function button_load_Callback(hObject, eventdata, handles)
% hObject    handle to button_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('out.txt', '�������� ���� ������');
if  ~isequal(filename,0)
    filename = fullfile(pathname, filename);
    
    % Prepare data
    FREQ = 102400;
    SPREAD = 10;

    M = dlmread(filename, '', 1, 0);
    
    handles.freq = FREQ / SPREAD;
    
    handles.T = M(1:SPREAD:end, 1);
    handles.X_filth = M(1:SPREAD:end, 2);
    handles.Y_filth = M(1:SPREAD:end, 3);
    handles.P_filth = M(1:SPREAD:end, 4);
    
    handles.t0 = handles.T(1);
    handles.t1 = handles.T(end);
    
    handles.L = str2double(get(handles.edit_L, 'String'));
    
    handles.X = handles.X_filth;
    handles.Y = handles.Y_filth;
    handles.P = handles.P_filth;
    
    handles.shift_X = str2double(get(handles.edit_shiftX, 'String'));
    handles.shift_Y = str2double(get(handles.edit_shiftY, 'String'));
    
    handles.multipler = 1e-1;
    
    handles = main_calculate(handles);
    
    % Show results
    set(handles.text_filename, 'String', filename);
    set(handles.edit_t1, 'String', handles.t1);
    set(handles.text_K, 'String', handles.K);
    
    axes(handles.axes_XY);
    hold on;
    grid on;
    
    handles.plot_X = plot(handles.T, handles.X);
    handles.plot_Y = plot(handles.T, handles.Y);
    handles.plot_t0_XY = vline(handles.t0, '', 't0');
    handles.plot_t1_XY = vline(handles.t1, '', 't1');
    legend('X', 'Y');
    
    axes(handles.axes_curve);
    hold on;
    axis equal;
    grid on;
    
    handles.plot_G = plot(handles.X, handles.Y);
    legend('G');
    
    axes(handles.axes_phi);
    hold on;
    grid on;
    
    handles.plot_phi = plot(handles.T, handles.phi);
    handles.plot_t0_phi = vline(handles.t0, '', 't0');
    handles.plot_t1_phi = vline(handles.t1, '', 't1');
    legend('phi');
    
    axes(handles.axes_P);
    hold on;
    grid on;
    
    handles.plot_P = plot(handles.T, handles.P);
    handles.plot_t0_P = vline(handles.t0, '', 't0');
    handles.plot_t1_P = vline(handles.t1, '', 't1');
    legend('P');
    
    axes(handles.axes_u);
    hold on;
    grid on;
    
    handles.plot_u = plot(handles.T(1:end-1), handles.u);
	handles.plot_t0_u = vline(handles.t0, '', 't0');
    handles.plot_t1_u = vline(handles.t1, '', 't1');
    legend('u');
    
    % Update handles structure
    guidata(hObject, handles);
end


% --- Executes on button press in button_filter<>.
function button_filter_Callback(hObject, eventdata, handles)
% hObject    handle to button_filterP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit_L_Callback(hObject, eventdata, handles)
% hObject    handle to edit_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.L = str2double(get(hObject, 'String'));
handles = update_K(handles);

% Update handles structure
guidata(hObject, handles);


function edit_t_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t<> (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tag = get(hObject, 'Tag');
val = str2double(get(hObject,'String'));

tokens = regexp(tag,'edit_(t\d)', 'tokens');
field = tokens{1}{1};

handles.(field) = val;

handles = update_K(handles);

% Update handles structure
guidata(hObject, handles);


function edit_shift_Callback(hObject, eventdata, handles)
% hObject    handle to edit_shift<> (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_shift<> as text
%        str2double(get(hObject,'String')) returns contents of edit_shift<> as a double


% --- Executes on button press in shift buttons.
function button_shift_Callback(hObject, eventdata, handles)
% hObject    handle to button_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in multipler radiobuttons.
function radiobutton_mulitpler_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function phi = phi(X, Y)

G = complex(X, Y);
phi = unwrap(angle(G));


function omega = omega(phi, freq)

omega = diff(phi) .* freq;


function u = u(omega, K)

u = omega .* K;


function K = K(L, phi0, phi1)

K = L / abs(phi1 - phi0);


function handles_out = main_calculate(handles)

handles.phi = phi(handles.X, handles.Y);
handles.omega = omega(handles.phi, handles.freq);

sample0 = int64(handles.t0 * handles.freq) + 1;
sample1 = int64(handles.t1 * handles.freq);

handles.K = K(handles.L, handles.phi(sample0), handles.phi(sample1));

handles.u = u(handles.omega, handles.K);

handles_out = handles;


function handles_out = update_XY(handles)

% Update data
handles.phi = phi(handles.X, handles.Y);
handles.omega = omega(handles.phi, handles.freq);
handles.u = u(handles.omega, handles.K);

% Update plots
handles.plot_X.YData = handles.X;
handles.plot_Y.YData = handles.Y;

handles.plot_G.XData = handles.X;
handles.plot_G.YData = handles.Y;

handles.plot_phi.YData = handles.phi;

handles.plot_u.YData = handles.u;

handles_out = handles;


function handles_out = update_K(handles)

% Update data
sample0 = int64(handles.t0 * handles.freq) + 1;
sample1 = int64(handles.t1 * handles.freq);

handles.K = K(handles.L, handles.phi(sample0), handles.phi(sample1));
handles.u = u(handles.omega, handles.K);

% Update plots
handles.text_K.('String') = handles.K;

handles.plot_u.YData = handles.u;

handles = update_t_plots(handles);

handles_out = handles;


function handles_out = update_t_plots(handles)

t0 = handles.t0;
t1 = handles.t1;

handles.plot_t0_XY.XData = [t0, t0];
handles.plot_t1_XY.XData = [t1, t1];

handles.plot_t0_phi.XData = [t0, t0];
handles.plot_t1_phi.XData = [t1, t1];

handles.plot_t0_P.XData = [t0, t0];
handles.plot_t1_P.XData = [t1, t1];

handles.plot_t0_u.XData = [t0, t0];
handles.plot_t1_u.XData = [t1, t1];

handles_out = handles;
