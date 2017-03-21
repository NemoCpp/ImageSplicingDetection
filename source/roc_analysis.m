
images_path = 'data/regions_module_test';
pattern = 'splicing';
folders = dir(images_path);
i = 1;

positive = zeros(0);
negative = zeros(0);
count = 0;
while i <= size(folders, 1)
    f = folders(i);
    disp(f.name);
    if(~strcmp(f.name, '.') && ~strcmp(f.name, '..') && ~f.isdir && strncmpi(f.name, pattern, length(pattern)))
        image = [images_path, '/', f.name];  
        data = load(image);
        positive = horzcat(positive, data.positive);
        negative = horzcat(negative, data.negative);
        
        Labels = [zeros(1, length(negative)) ones(1, length(positive))];
        Scores = [negative positive];

        %Curva ROC
        %plotroc(Labels,Scores)

        %Recupero valore di soglia ottimale
        [X,Y,T,AUC,OPTROCPT] = perfcurve(Labels,Scores,1);
        ACC = ((1-X)+Y)/2;
        %Calcolo accuracy (M)
        [M idx] = max(ACC);
        fprintf('\tAccuracy: %f\n', M);
        %Valore di soglia
        Th = T(idx);
        fprintf('\tThreshold: %f\n', Th);
        
        count = count + 1;
    end
    i=i+1;
    
    %if count == 1
        %break;
    %end
end

%Labels ottenute (0 e 1)
%Labels=[zeros(100,1)' ones(100,1)'];
%Scores relativi (valori ottenuti)
%Score =[rand(100,1)' 10*rand(100,1)'];

