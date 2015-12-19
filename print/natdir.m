% return id s inside a folder in natural order
function ids = natdir(thepath)
files = dir(thepath);
for i = 1:length(files)
    [~, ids{i}, ~] = fileparts(files(i).name);
end
ids = natsortfiles(ids);
end

function [X,ndx] = natsortfiles(X,varargin)
% Natural-order sort of a cell array of filenames/filepaths, with customizable numeric format.
%
% (c) 2015 Stephen Cobeldick
%
% Sort a cell array of filenames or filepaths, sorting the strings by both character
% order and the values of any numeric substrings that occur within the strings.
%
% Syntax:
%  Y = natsortfiles(X)
%  Y = natsortfiles(X,xpr)
%  Y = natsortfiles(X,xpr,<options>)
% [Y,ndx] = natsortfiles(X,...)
%
% The filenames and file extensions are sorted separately. This ensures that
% shorter filenames sort before longer (i.e. a dictionary sort). Note that
% a standard sort of filenames will sort any of char(0:45), including the
% characters [ !"#$%&'()*+,-], before the file extension character (period).
%
% Similarly the file separator character within filepaths can cause longer
% directory names to sort before short ones (char(0:46)<'/' and char(0:91)<'\').
% This submission splits filepaths at each file separator character and sorts
% every level of the directory hierarchy separately, ensuring that shorter
% directory names sort before longer, regardless of the characters in the names.
%
% Note: requires the function "natsort" (File Exchange 34464). All optional
%       inputs are passed directly to "natsort": see "natsort" for information
%       on case sensitivity, sort direction, and numeric substring matching.
%
% To sort all of the strings in a cell array use "natsort" (File Exchange 34464).
% To sort the rows of a cell array of strings use "natsortrows" (File Exchange 47433).
%
% See also NATSORT NATSORTROWS SORT SORTROWS SIPRE BIPRE CELLSTR REGEXP FILEPARTS FILESEP FULLFILE PWD DIR
%
% ### Examples ###
%
% A = {'test_x.m'; 'test-x.m'; 'test.m'};
% sort(A) % sorts '-' before '.'
%  ans = {
%     'test-x.m'
%     'test.m'
%     'test_x.m'}
% natsortfiles(A) % shorter names first (i.e. like a dictionary sort)
%  ans = {
%     'test.m'
%     'test-x.m'
%     'test_x.m'}
%
% B = {'test2.m'; 'test10-old.m'; 'test.m'; 'test10.m'; 'test1.m'};
% sort(B)
%  ans = {
%     'test.m'
%     'test1.m'
%     'test10-old.m'
%     'test10.m'
%     'test2.m'}
% natsortfiles(B) % correct numeric order and shortest first:
%  ans = {
%     'test.m'
%     'test1.m'
%     'test2.m'
%     'test10.m'
%     'test10-old.m'}
%
% C = {... % This is the order from the standard "sort" function:
%     'C:\Anna1\noise.mp10',...
%     'C:\Anna1\noise.mp3',...
%     'C:\Anna1\noise.mpX',...
%     'C:\Anna1archive.zip',...
%     'C:\Anna20\dir10\weigh.m',...
%     'C:\Anna20\dir1\weigh.m',...
%     'C:\Anna20\dir2\weigh.m',...
%     'C:\Anna3-all\archive.zip',...
%     'C:\Anna3\budget.pdf',...
%     'C:\Anna_archive.zip',...
%     'C:\Bob10\article.doc',...
%     'C:\Bob10_article.tex',...
%     'C:\Bob1\menu.png',...
%     'C:\Bob2\Work\test1.txt',...
%     'C:\Bob2\Work\test10.txt',...
%     'C:\Bob2\Work\test2.txt',...
%     'C:\info.log',...
%     'C:\info.txt',...
%     'C:\info1.log',...
%     'C:\info10.log',...
%     'C:\info2.log',...
%     'C:\info2.txt'};
% % Because '\' is treated as a character, a naive natural-order sort mixes
% % the subdirectory hierarchy, and longer directory names may come first:
% natsort(C)
%  ans = {
%     'C:\Anna1archive.zip'
%     'C:\Anna1\noise.mp3'
%     'C:\Anna1\noise.mp10'
%     'C:\Anna1\noise.mpX'
%     'C:\Anna3-all\archive.zip'
%     'C:\Anna3\budget.pdf'
%     'C:\Anna20\dir1\weigh.m'
%     'C:\Anna20\dir2\weigh.m'
%     'C:\Anna20\dir10\weigh.m'
%     'C:\Anna_archive.zip'
%     'C:\Bob1\menu.png'
%     'C:\Bob2\Work\test1.txt'
%     'C:\Bob2\Work\test2.txt'
%     'C:\Bob2\Work\test10.txt'
%     'C:\Bob10\article.doc'
%     'C:\Bob10_article.tex'
%     'C:\info.log'
%     'C:\info.txt'
%     'C:\info1.log'
%     'C:\info2.log'
%     'C:\info2.txt'
%     'C:\info10.log'}
% % This function sorts shorter directory names sort before longer (just
% % like a dictionary), and preserves the subdirectory hierarchy:
% natsortfiles(C)
%  ans = {
%     'C:\Anna1archive.zip'
%     'C:\Anna_archive.zip'
%     'C:\Bob10_article.tex'
%     'C:\info.log'
%     'C:\info.txt'
%     'C:\info1.log'
%     'C:\info2.log'
%     'C:\info2.txt'
%     'C:\info10.log'
%     'C:\Anna1\noise.mp3'
%     'C:\Anna1\noise.mp10'
%     'C:\Anna1\noise.mpX'
%     'C:\Anna3\budget.pdf'
%     'C:\Anna3-all\archive.zip'
%     'C:\Anna20\dir1\weigh.m'
%     'C:\Anna20\dir2\weigh.m'
%     'C:\Anna20\dir10\weigh.m'
%     'C:\Bob1\menu.png'
%     'C:\Bob2\Work\test1.txt'
%     'C:\Bob2\Work\test2.txt'
%     'C:\Bob2\Work\test10.txt'
%     'C:\Bob10\article.doc'}
%
% ### Input and Output Arguments ###
%
% Please see "natsort" for a full description of <xpr> and the <options>.
%
% Inputs (*=default):
%  X   = CellOfStrings, with filenames or filepaths to be sorted.
%  xpr = StringToken, regular expression to detect numeric substrings, '\d+'*.
%  <options> can be supplied in any order and are passed directly to "natsort".
%
% Outputs:
%  Y   = CellOfStrings, <X> with the filenames sorted according to <options>.
%  ndx = NumericMatrix, same size as <X>. Indices such that Y = X(ndx).
%
% [Y,ndx] = natsortrows(X,*xpr,<options>)

assert(iscellstr(X),'First input <X> must be a cell array of strings.')
%
% Split full filepaths into {path,name,extension}:
[pth,nam,ext] = cellfun(@fileparts,X(:),'UniformOutput',false);
% Split path into {root,subdir,subsubdir,...}
%pth = regexp(pth,filesep,'split'); % OS dependent
pth = regexp(pth,'[/\\]','split'); % either / or \
len = cellfun('length',pth);
vec(1:numel(len)) = {''};
%
% Natural-order sort of the extension, name and directories:
[~,ndx] = natsort(ext,varargin{:});
[~,ind] = natsort(nam(ndx),varargin{:});
ndx = ndx(ind);
for k = max(len):-1:1
    idx = len>=k;
    vec(~idx) = {''};
    vec(idx) = cellfun(@(c)c(k),pth(idx));
    [~,ind] = natsort(vec(ndx),varargin{:});
    ndx = ndx(ind);
end
%
% Return sorted array and indices:
ndx = reshape(ndx,size(X));
X = X(ndx);
%
end
%----------------------------------------------------------------------END:natsortfiles

function [X,ndx,dbg] = natsort(X,xpr,varargin) %#ok<*SPERR>
% Natural-order sort of a cell array of strings, with customizable numeric format.
%
% (c) 2015 Stephen Cobeldick
%
% ### Function ###
%
% Sort a cell array of strings by both character order and the values of
% any numeric substrings that occur within the strings. The default sort
% is case-insensitive ascending with integer numeric substrings: optional
% inputs control the sort direction, case sensitivity, and the numeric
% substring matching (see the section 'Numeric Substrings' below).
%
% Syntax:
%  Y = natsort(X)
%  Y = natsort(X,xpr)
%  Y = natsort(X,xpr,<options>)
% [Y,ndx] = natsort(X,...);
%
% To sort filenames or filepaths use "natsortfiles" (File Exchange 47434).
% To sort the rows of a cell array of strings use "natsortrows" (File Exchange 47433).
%
% See also NATSORTFILES NATSORTROWS SORTROWS SORT CELLSTR REGEXP SSCANF NUM2ORDINAL NUM2WORDS BIPRE SIPRE INTMAX
%
% ### Numeric Substrings ###
%
% By default any consecutive digit characters are identified as being numeric
% substrings. The optional regular expression pattern <xpr> allows us to
% include a +/- sign, a decimal point, exponent E-notation or any literal
% characters, quantifiers or look-around requirements. For more information:
% http://www.mathworks.com/help/matlab/matlab_prog/regular-expressions.html
%
% The substrings are then parsed by "sscanf" into their numeric values, using
% either the *default format '%f', or the user-supplied format specifier.
% The numeric array's class type is determined by the format specifier.
%
% This table shows some example regular expression patterns for some common
% notations and ways of writing numbers (see 'Examples' below for more):
%
% <xpr> Regular | Numeric Substring| Numeric Substring             | "sscanf"
% Expression:   | Match Examples:  | Match Description:            | Format specifier:
% ==============|==================|===============================|==================
% *         \d+ | 0, 1, 234, 56789 | unsigned integer              | %f  %u  %lu  %i
% --------------|------------------|-------------------------------|------------------
%     (-|+)?\d+ | -1, 23, +45, 678 | integer with optional +/- sign| %f  %d  %ld  %i
% --------------|------------------|-------------------------------|------------------
%   \d+(\.\d+)? | 012, 3.45, 678.9 | integer or decimal            | %f
% --------------|------------------|-------------------------------|------------------
%   \d+|Inf|NaN | 123456, Inf, NaN | integer, infinite or NaN value| %f
% --------------|------------------|-------------------------------|------------------
%  \d+\.\d+e\d+ | 0.123e4, 5.67e08 | exponential notation          | %f
% --------------|------------------|-------------------------------|------------------
%  0[0-7]+      | 012, 03456, 0700 | octal prefix & notation       | %o  %i
% --------------|------------------|-------------------------------|------------------
%  0X[0-9A-F]+  | 0X0, 0XFF, 0X7C4 | hexadecimal prefix & notation | %x  %i
% --------------|------------------|-------------------------------|------------------
%  0B[01]+      | 0B101, 0B0010111 | binary prefix & notation      | %b
% --------------|------------------|-------------------------------|------------------
%
% The "sscanf" format specifier (including %b) can include literal characters
% and skipped fields. The octal, hexadecimal and binary prefixes are optional.
% For more information: http://www.mathworks.com/help/matlab/ref/sscanf.html
%
% ### Relative Sort Order ###
%
% The sort order of the numeric substrings relative to the characters
% can be controlled by providing one of the following string options:
%
% Option Token:| Relative Sort Order:                 | Example:
% =============|======================================|====================
% 'beforechar' | numerics < char(0:end)               | '1' < '.' < 'A'
% -------------|--------------------------------------|--------------------
% 'afterchar'  | char(0:end) < numerics               | '.' < 'A' < '1'
% -------------|--------------------------------------|--------------------
% 'asdigit'   *| char(0:47) < numerics < char(58:end) | '.' < '1' < 'A'
% -------------|--------------------------------------|--------------------
%
% Note that the digit characters have character values 48 to 57, inclusive.
%
% ### Examples ###
%
% Integer numeric substrings:
% A = {'a2', 'a', 'a10', 'a1'};
% sort(A)
%  ans = {'a', 'a1', 'a10', 'a2'}
% natsort(A)
%  ans = {'a', 'a1', 'a2', 'a10'}
%
% % Multiple numeric substrings (e.g. release version numbers):
% B = {'v10.6', 'v9.10', 'v9.5', 'v10.10', 'v9.10.20', 'v9.10.8'};
% sort(B)
%  ans = {'v10.10', 'v10.6', 'v9.10', 'v9.10.20', 'v9.10.8', 'v9.5'}
% natsort(B)
%  ans = {'v9.5', 'v9.10', 'v9.10.8', 'v9.10.20', 'v10.6', 'v10.10'}
%
% % Integer, decimal or Inf numeric substrings, possibly with +/- signs:
% C = {'test102', 'test11.5', 'test-1.4', 'test', 'test-Inf', 'test+0.3'};
% sort(C)
%  ans = {'test', 'test+0.3', 'test-1.4', 'test-Inf', 'test102', 'test11.5'}
% natsort(C, '(-|+)?(Inf|\d+(\.\d+)?)')
%  ans = {'test', 'test-Inf', 'test-1.4', 'test+0.3', 'test11.5', 'test102'}
%
% % Integer or decimal numeric substrings, possibly with an exponent:
% D = {'0.56e007', '', '4.3E-2', '10000', '9.8'};
% sort(D)
%  ans = {'', '0.56e007', '10000', '4.3E-2', '9.8'}
% natsort(D, '\d+(\.\d+)?(e(+|-)?\d+)?')
%  ans = {'', '4.3E-2', '9.8', '10000', '0.56e007'}
%
% % Hexadecimal numeric substrings (possibly with '0X' prefix):
% E = {'a0X7C4z', 'a0X5z', 'a0X18z', 'aFz'};
% sort(E)
%  ans = {'a0X18z', 'a0X5z', 'a0X7C4z', 'aFz'}
% natsort(E, '(?<=a)(0X)?[0-9A-F]+', '%x')
%  ans = {'a0X5z', 'aFz', 'a0X18z', 'a0X7C4z'}
%
% % Binary numeric substrings (possibly with '0B' prefix):
% F = {'a11111000100z', 'a0B101z', 'a0B000000000000011000z', 'a1111z'};
% sort(F)
%  ans = {'a0B000000000000011000z', 'a0B101z', 'a11111000100z', 'a1111z'}
% natsort(F, '(0B)?[01]+', '%b')
%  ans = {'a0B101z', 'a1111z', 'a0B000000000000011000z', 'a11111000100z'}
%
% % uint64 numeric substrings (with full precision!):
% natsort({'a18446744073709551615z', 'a18446744073709551614z'}, '\d+', '%lu')
%  ans =  {'a18446744073709551614z', 'a18446744073709551615z'}
%
% % Case sensitivity:
% G = {'a2', 'A20', 'A1', 'a10', 'A2', 'a1'};
% natsort(G, '\d+', 'ignorecase') % default
%  ans =  {'A1', 'a1', 'a2', 'A2', 'a10', 'A20'}
% natsort(G, '\d+', 'matchcase')
%  ans =  {'A1', 'A2', 'A20', 'a1', 'a2', 'a10'}
%
% % Sort direction:
% H = {'2', 'a', '3', 'B', '1'};
% natsort(H, '\d+', 'ascend') % default
%  ans =  {'1', '2', '3', 'a', 'B'}
% natsort(H, '\d+', 'descend')
%  ans =  {'B', 'a', '3', '2', '1'}
%
% % Relative sort-order of numeric substrings compared to characters:
% X = num2cell(char(32+randperm(63)));
% cell2mat(natsort(X, '\d+', 'asdigit')) % default
%  ans = '!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_'
% cell2mat(natsort(X, '\d+', 'beforechar'))
%  ans = '0123456789!"#$%&'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_'
% cell2mat(natsort(X, '\d+', 'afterchar'))
%  ans = '!"#$%&'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_0123456789'
%
% ### Input and Output Arguments ###
%
% Inputs (*=default):
%   X   = CellOfStrings, with strings to be sorted into natural-order.
%   xpr = StringToken, regular expression to detect numeric substrings, *'\d+'.
% <options> string tokens can be entered in any order, as many as required:
%   - Case sensitive/insensitive matching: 'matchcase'/'ignorecase'*.
%   - Sort direction: 'descend'/'ascend'*.
%   - Relative sort of numerics: 'beforechar'/'afterchar'/'asdigit'*.
%   - The "sscanf" numeric conversion format, e.g.: *'%f', '%x', '%i', etc.
%
% Outputs:
%   Y   = CellOfStrings, <X> with all strings sorted into natural-order.
%   ndx = NumericArray, such that Y = X(ndx). The same size as <X>.
%   dbg = CellArray of all parsed characters and numeric values. Each row is
%         one string, linear-indexed from <X>. Helps to debug string parsing.
%
% [X,ndx,dbg] = natsort(X,*xpr,<options>)

% ### Input Wrangling ###
%
assert(iscellstr(X),'First input <X> must be a cell array of strings.')
%
% Regular expression:
if nargin<2
    xpr = '\d+';
else
    assert(ischar(xpr)&&isrow(xpr),'Second input <xpr> must be a string regular expression.')
end
%
% Optional arguments:
assert(iscellstr(varargin),'All optional arguments must be string tokens.')
% Character case matching:
MatL = strcmp(varargin,'matchcase');
CasL = strcmp(varargin,'ignorecase')|MatL;
% Sort direction:
DcdL = strcmp(varargin,'descend');
DrnL = strcmp(varargin,'ascend')|DcdL;
% Relative sort-order of numerics compared to characters:
BefL = strcmp(varargin,'beforechar');
AftL = strcmp(varargin,'afterchar');
RsoL = strcmp(varargin,'asdigit')|BefL|AftL;
% "sscanf" conversion format:
FmtL = ~(CasL|DrnL|RsoL);
%
if sum(DrnL)>1
    error('Sort direction is overspecified:%s\b.',sprintf(' ''%s'',',varargin{DrnL}))
end
%
if sum(RsoL)>1
    error('Relative sort-order is overspecified:%s\b.',sprintf(' ''%s'',',varargin{RsoL}))
end
%
FmtN = sum(FmtL);
if FmtN>1
    error('Unsupported optional arguments:%s\b.',sprintf(' ''%s'',',varargin{FmtL}))
end
%
% ### Split Strings ###
%
% Split strings into numeric and remaining substrings:
[MtS,MtE,MtC,SpC] = regexpi(X(:),xpr,'start','end','match','split',varargin{CasL});
%
% Determine lengths:
MtcD = cellfun(@minus,MtE,MtS,'UniformOutput',false);
LenZ = cellfun('length',X(:))-cellfun(@sum,MtcD);
LenY = max(LenZ);
LenX = numel(MtC);
%
dbg = cell(LenX,LenY);
NuI = false(LenX,LenY);
ChI = false(LenX,LenY);
ChA = char(+ChI);
%
ndx = 1:LenX;
for k = ndx(LenZ>0)
    % Determine indices of numerics and characters:
    ChI(k,1:LenZ(k)) = true;
    if ~isempty(MtS{k})
        tmp = MtE{k} - cumsum(MtcD{k});
        dbg(k,tmp) = MtC{k};
        NuI(k,tmp) = true;
        ChI(k,tmp) = false;
    end
    % Transfer characters into char array:
    if any(ChI(k,:))
        tmp = SpC{k};
        ChA(k,ChI(k,:)) = [tmp{:}];
    end
end
%
% ### Convert Numeric Substrings ###
%
if FmtN % One format specifier
    fmt = varargin{FmtL};
    [T,S] = regexp(fmt,'%(\d*)(b|d|i|u|o|x|f|e|g|l(d|i|u|o|x))','tokens','split');
    assert(isscalar(T),'Unsupported optional argument: ''%s''',fmt)
    assert(isempty(T{1}{1}),'Format specifier cannot include field-width: ''%s''',fmt)
    switch T{1}{2}(1)
        case 'b' % binary
            fmt = regexprep(fmt,'%b','%[01]'); % allow for literals.
            val = dbg(NuI);
            if numel(S{1})<2 || ~strcmpi('0B',S{1}(end-1:end))
                % Remove '0B' if not specified in the format string:
                val = regexprep(val,'(0B)?([01]+)','$2','ignorecase');
            end
            val = cellfun(@(s)sscanf(s,fmt),val, 'UniformOutput',false);
            NuA(NuI) = cellfun(@(s)sum(pow2(s-48,numel(s)-1:-1:0)),val);
        case 'l' % 64-bit
            NuA(NuI) = cellfun(@(s)sscanf(s,fmt),dbg(NuI)); %slow!
        otherwise % double
            NuA(NuI) = sscanf(sprintf('%s\v',dbg{NuI}),[fmt,'\v']); % fast!
    end
else % No format specifier -> double
    NuA(NuI) = sscanf(sprintf('%s\v',dbg{NuI}),'%f\v');
end
% Note: NuA's class is determined by "sscanf".
NuA(~NuI) = 0;
NuA = reshape(NuA,LenX,LenY);
%
% ### Debugging Array ###
%
if nargout>2
    for k = reshape(find(NuI),1,[])
        dbg{k} = NuA(k);
    end
    for k = reshape(find(ChI),1,[])
        dbg{k} = ChA(k);
    end
end
%
% ### Sort ###
%
if ~any(MatL)% ignorecase
    ChA = upper(ChA);
end
%
bel = any(BefL); % BeforeChar
afl = any(AftL); % AfterChar
dcl = any(DcdL); % Descend
%
ide = ndx.';
% From the last column to the first...
for n = LenY:-1:1
    % ...sort the characters and numeric values:
    [C,idc] = sort(ChA(ndx,n),1,varargin{DrnL});
    [~,idn] = sort(NuA(ndx,n),1,varargin{DrnL});
    % ...keep only relevant indices:
    jdc = ChI(ndx(idc),n); % character
    jdn = NuI(ndx(idn),n); % numeric
    jde = ~ChI(ndx,n)&~NuI(ndx,n); % empty
    % ...define the sort-order of numerics and characters:
    jdo = afl|(~bel&C<48);
    % ...then combine these indices in the requested direction:
    if dcl
        ndx = ndx([idc(jdc&~jdo);idn(jdn);idc(jdc&jdo);ide(jde)]);
    else
        ndx = ndx([ide(jde);idc(jdc&jdo);idn(jdn);idc(jdc&~jdo)]);
    end
end
%
ndx  = reshape(ndx,size(X));
X = X(ndx);
%
end
%----------------------------------------------------------------------END:natsort