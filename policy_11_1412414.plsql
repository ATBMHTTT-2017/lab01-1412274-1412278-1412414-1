------------------------------------------------------------------------Tạo các thành phần policy. ---------------------------------------------------------------------
-- Quyền tạo ra các thành phần của label
GRANT EXECUTE ON SA_COMPONENTS TO lab01;
-- Quyền tạoo các label
GRANT EXECUTE ON SA_LABEL_ADMIN TO lab01;
-- Quyền gán policy cho các bảng
GRANT EXECUTE ON SA_POLICY_ADMIN TO lab01;
--Quyền gán label cho tài khoản
GRANT EXECUTE ON SA_USER_ADMIN TO lab01;
--Chuyển chuổi thành số của label
GRANT EXECUTE ON CHAR_TO_LABEL TO lab01;
--Grant quyền sa_audit_admin
GRANT EXECUTE ON sa_audit_admin TO lab01;
--Grant quyền LBAC_DBA
GRANT LBAC_DBA TO lab01;
--Grant quyền sa_sysdba 
GRANT EXECUTE ON sa_sysdba TO lab01;
--Grant quyền to_lbac_data_label
GRANT EXECUTE ON to_lbac_data_label TO lab01;

--Tạo policy
EXECUTE SA_SYSDBA.CREATE_POLICY('ACCESS_DUAN', 'OLS_DUAN');

--Grant role ACCESS_DUAN_DBA cho user lab01
GRANT ACCESS_DUAN_DBA TO lab01;

--Tạo các thành phần level cho chính sách ACCESS_DUAN
EXEC SA_COMPONENTS.CREATE_LEVEL('ACCESS_DUAN', 9000, 'BMC', 'Bí mật cao');
EXEC SA_COMPONENTS.CREATE_LEVEL('ACCESS_DUAN', 8000, 'BM', 'Bí mật');
EXEC SA_COMPONENTS.CREATE_LEVEL('ACCESS_DUAN', 7000, 'GH', 'Giới hạn');
EXEC SA_COMPONENTS.CREATE_LEVEL('ACCESS_DUAN', 6000, 'TT', 'Thông thường');

--Tạo compartment
EXEC SA_COMPONENTS.CREATE_COMPARTMENT('ACCESS_DUAN', 3000, 'NS', 'Nhân sự');
EXEC SA_COMPONENTS.CREATE_COMPARTMENT('ACCESS_DUAN', 2000, 'KT', 'Kế toán');
EXEC SA_COMPONENTS.CREATE_COMPARTMENT('ACCESS_DUAN', 1000, 'KH', 'Kế hoạch');

--Tạo group
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 1, 'CT', 'Công ty', NULL);
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 4, 'HCM', 'Hồ Chí Minh', 'CT');
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 5, 'HN', 'Hà Nội', 'CT');
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 3, 'DN', 'Đà Nẵng', 'CT');
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 6, 'HP', 'Hải Phòng', 'CT');
EXEC SA_COMPONENTS.CREATE_GROUP('ACCESS_DUAN', 2, 'CTH', 'Cần Thơ', 'CT');

--
CREATE OR REPLACE FUNCTION taoLabelDuAn(phongChuTri  IN  VARCHAR2)
RETURN LBACSYS.LBAC_LABEL AS
  labelDuAn  VARCHAR2(50);
BEGIN
  labelDuAn := 'GH:' || substr(phongChuTri,1, 2) || ':' || substr(phongChuTri, 3);
  RETURN TO_LBAC_DATA_LABEL('ACCESS_DUAN', labelDuAn);
END taoLabelDuAn;

--Gán chính sách cho bảng duAn
EXEC SA_POLICY_ADMIN.APPLY_TABLE_POLICY('ACCESS_DUAN', 'lab01', 'duAn', 'NO_CONTROL');

--Khởi tạo nhãn
UPDATE lab01.duAn
SET OLS_DUAN = CHAR_TO_LABEL('ACCESS_DUAN','TT');
COMMIT;

--Gỡ policy
EXEC SA_POLICY_ADMIN.REMOVE_TABLE_POLICY('ACCESS_DUAN','lab01','duAn');

--Áp dụng lại policy
begin SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
  POLICY_NAME     => 'ACCESS_DUAN',
  SCHEMA_NAME     => 'lab01',
  TABLE_NAME      => 'duAn',
  TABLE_OPTIONS   => 'READ_CONTROL,WRITE_CONTROL,CHECK_CONTROL');
end;

--Tạo nhãn
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1500, 'GH:NS:HCM');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1400, 'GH:NS:HN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1300, 'GH:NS:DN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1200, 'GH:NS:HP');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1100, 'GH:NS:CTH');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 1000, 'GH:KT:HCM');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 900, 'GH:KT:HN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 800, 'GH:KT:DN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 700, 'GH:KT:HP');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 600, 'GH:KT:CTH');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 500, 'GH:KH:HCM');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 400, 'GH:KH:HN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 300, 'GH:KH:DN');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 200, 'GH:KH:HP');
EXEC SA_LABEL_ADMIN.CREATE_LABEL('ACCESS_DUAN', 100, 'GH:KH:CTH');