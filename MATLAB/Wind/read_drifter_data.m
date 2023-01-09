function drifter_data = read_drifter_data(path)

files = {dir(path).name};
count = 0;
for file = files
    if strcmp(file, ".") || strcmp(file, "..")
        continue;
    end
    file_name = split(string(file), ".");
    name = file_name(1);

    count = count + 1;

    drifter_data(count).name = name;

    file_content_struct = readtable(path + file);
    drifter_data(count).Times = datenum([file_content_struct.DateTime]);
    drifter_data(count).Longs = [file_content_struct.Longitude];
    drifter_data(count).Lats = [file_content_struct.Latitude];


end

end