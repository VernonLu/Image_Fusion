function varargout = MainWnd(varargin)
% MAINWND MATLAB code for MainWnd.fig
%      MAINWND, by itself, creates a new MAINWND or raises the existing
%      singleton*.
%
%      H = MAINWND returns the handle to a new MAINWND or the handle to
%      the existing singleton*.
%
%      MAINWND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINWND.M with the given input arguments.
%
%      MAINWND('Property','Value',...) creates a new MAINWND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainWnd_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainWnd_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainWnd

% Last Modified by GUIDE v2.5 03-Jul-2018 09:11:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainWnd_OpeningFcn, ...
    'gui_OutputFcn',  @MainWnd_OutputFcn, ...
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


% --- Executes just before MainWnd is made visible.
function MainWnd_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainWnd (see VARARGIN)

% Choose default command line output for MainWnd
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainWnd wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainWnd_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in addImage1.
function addImage1_Callback(hObject, eventdata, handles)
% hObject    handle to addImage1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global source
[file,path] = uigetfile('*.jpg;*.tif;*.png;*.gif','Select Image');
filename = strcat(path,file);
source = imread(filename);
axes(handles.axes1);
imshow(source);
setappdata(handles.axes1,'image',source);



% --- Executes on button press in addImage2.
function addImage2_Callback(hObject, eventdata, handles)
% hObject    handle to addImage2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global target
[file,path] = uigetfile('*.jpg;*.tif;*.png;*.gif','Select Image');
filename = strcat(path,file);
target = imread(filename);
axes(handles.axes2);
imshow(target);
setappdata(handles.axes2,'image',target);

% --- Executes on button press in generateButton.
function generateButton_Callback(hObject, eventdata, handles)
% hObject    handle to generateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global source target posX posY dest

srcTemp = cutborder(source);
[srcHeight, srcWidth, ~] = size(srcTemp);

% ??????????
srcBound = boundaries(srcTemp(:,:,4),8,'cw');
srcBound = srcBound{1};

% ??????????????
[srcX,srcY] = find(srcTemp(:,:,4) - uint8(bwperim(srcTemp(:,:,4))));

tgtTemp = target;
[tgtHeight, tgtWidth, ~] = size(tgtTemp);
tgtMask = zeros(tgtHeight, tgtWidth);
for i = 1:srcHeight
    for j = 1:srcWidth
        if i + posX <= tgtHeight && i + posX > 0 && j + posY <= tgtWidth && j + posY > 0
            tgtMask(i+posX,j+posY) = srcTemp(i, j, 4);
        end
    end
end
tgtBound = boundaries(tgtMask, 8, 'cw');
tgtBound = tgtBound{1};
[tgtX, tgtY] = find(uint8(tgtMask) - uint8(bwperim(tgtMask)));

mvc = MVC(srcX,srcY,srcBound);

dest = tgtTemp;

dest(:,:,1) =  Cloner(mvc, srcBound, tgtBound, srcX, srcY, tgtX, tgtY, srcTemp(:, :, 1), tgtTemp(:, :, 1));
dest(:,:,2) =  Cloner(mvc, srcBound, tgtBound, srcX, srcY, tgtX, tgtY, srcTemp(:, :, 2), tgtTemp(:, :, 2));
dest(:,:,3) =  Cloner(mvc, srcBound, tgtBound, srcX, srcY, tgtX, tgtY, srcTemp(:, :, 3), tgtTemp(:, :, 3));

dest = uint8(real(dest));




% alpha blending
% [tgtRow, tgtCol, tgtLayer] = size(target);
% [srcRow, srcCol, srcLayer] = size(srcTemp);
% alpha = blur(srcTemp,20);
% dest = target;
% for i = 1:srcCol
%     for j = 1:srcRow
%         if i + posX > tgtCol || i + posX <= 0 || j + posY > tgtRow || j + posY <= 0
%             continue;
%         end
%         if alpha(j, i) ~= 0
%             dest(posY + j, posX + i, :) = (1 - alpha(j, i)) * dest(posY + j, posX + i, :) + alpha(j, i) * srcTemp(j, i, 1:3);
%         end
%     end
% end



axes(handles.axes3);
imshow(dest);


% --- Executes on button press in drawRegion.
function drawRegion_Callback(hObject, eventdata, handles)
% hObject    handle to drawRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global source
figure(1), imshow(source(:,:,1:3));
fh = imfreehand();
srcMask = createMask(fh);
close(figure(1));

source(:,:,4) = srcMask;
boundary = boundaries(source(:,:,4),8,'cw');
boundary = boundary{1};
% [count,~] = size(boundary);
axes(handles.axes1);
imshow(source(:,:,1:3));
hold on;
plot(boundary(:, 2), boundary(:, 1), 'r');
hold off;

% --- Executes on button press in selectPosition.
function selectPosition_Callback(hObject, eventdata, handles)
% hObject    handle to selectPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global target posX posY
figure(2);
imshow(target);
[posX, posY] = ginput(1);
posX = floor(posX);
posY = floor(posY);
close(figure(2));


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dest
[FileName,PathName] = uiputfile({'*.jpg';'*.png'},'Save Image');
str = strcat(PathName,FileName);
imwrite(dest,str);
