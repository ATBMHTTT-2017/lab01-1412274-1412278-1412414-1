----------------------------------------------Chỉ trưởng phòng được thêm thông tin và cập nhật vào dự án (DAC)-------------------------------------------------------------------
grant insert, update on DuAN to truongPhong;

begin
for truongPhong in (select truongPhong from lab01.phongBan)
loop
  execute immediate 'grant truongPhong to ' || truongPhong.truongPhong; 
end loop;
end;