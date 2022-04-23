
/* Cleaning Data in SQL Queries */

SELECT * from APPBITEST.nashville_housing;


SELECT TO_CHAR(TO_DATE(saledate,'MONTH DD, YYYY') ,'yy-mm-dd') from APPBITEST.nashville_housing;

----- Populate Property Address data

Select *
from APPBITEST.nashville_housing
where propertyAddress is null
order by parcelid;


Select a.parcelid,a.propertyaddress,a.parcelid,b.propertyaddress,NULLIF(b.propertyaddress,a.propertyaddress)
FROM APPBITEST.nashville_housing a
JOIN APPBITEST.nashville_housing b
    on a.parcelid = b.parcelid
    And a.uniqueid != b.uniqueid
    where a.propertyaddress is null;
    
Update a set APPBITEST.nashville_housing.propertyaddress =(SELECT NULLIF(b.propertyaddress,a.propertyaddress)
FROM APPBITEST.nashville_housing a
JOIN APPBITEST.nashville_housing b
    on a.parcelid = b.parcelid
    And a.uniqueid != b.uniqueid
     where a.propertyaddress is null); ---- Not Updated 
     
 ---- Breaking out Address into individual columns (Address, City, State)
 
 
 Select  propertyaddress
from APPBITEST.nashville_housing
--where propertyAddress is null
--order by parcelid;

SELECT
SUBSTR(PROPERTYADDRESS,1, INSTR(PROPERTYADDRESS, ',', 1 )-1) AS ADDRESS,
SUBSTR(PROPERTYADDRESS,INSTR(PROPERTYADDRESS, ',', 1 )+1,LENGTH(PROPERTYADDRESS)-1) AS ADDRESS1
FROM
APPBITEST.nashville_housing;


SELECT
 INSTR(PROPERTYADDRESS, ',', 1)
FROM
APPBITEST.nashville_housing;


ALTER TABLE APPBITEST.nashville_housing
ADD PropertySplitAddress VARCHAR2(128 BYTE);

UPDATE APPBITEST.nashville_housing
SET PropertySplitAddress = SUBSTR(PROPERTYADDRESS,1, INSTR(PROPERTYADDRESS, ',', 1 )-1);


ALTER TABLE APPBITEST.nashville_housing
ADD PropertySplitCity VARCHAR2(128 BYTE);

UPDATE APPBITEST.nashville_housing
SET PropertySplitCity = SUBSTR(PROPERTYADDRESS,INSTR(PROPERTYADDRESS, ',', 1 )+1,LENGTH(PROPERTYADDRESS)-1);


SELECT
 *
FROM
nashville_housing;


SELECT OwnerAddress 
FROM nashville_housing;

SELECT 
OwnerAddress , SUBSTR(OwnerAddress,1, INSTR(OwnerAddress, ',', 1 )-1) AS ADDRESS,
               SUBSTR(OwnerAddress, INSTR(OwnerAddress, ',', 1 )+1,INSTR(OwnerAddress, ',', 1 )+1) AS ADDRESS,
               SUBSTR(OwnerAddress, INSTR(OwnerAddress, ',', 1 )+1,INSTR(OwnerAddress, ',', 1 )+1)
FROM nashville_housing;  


---Change Y and N to Yes and No in "Sold as Vacant" Field

SELECT Distinct(soldAsVacant),Count(soldasvacant)
FROM APPBITEST.nashville_housing
Group By soldasvacant
order by 2;

SELECT soldasvacant,
   CASE when soldasvacant = 'Y' THEN 'Yes'
        when soldasvacant = 'N' THEN 'No'
        ELSE soldasvacant
        END
FROM nashville_housing;



UPDATE  nashville_housing
SET soldasvacant = CASE when soldasvacant = 'Y' THEN 'Yes'
        when soldasvacant = 'N' THEN 'No'
        ELSE soldasvacant
        END
----------------------------------------------------------------------------------      
        
---- Remove Duplicates --------------
WITH ROWNUMCTE AS(
SELECT *,
       ROW_NUMBER() OVER (
       PARTITION  BY parcelid,
                     propertyaddress,
                     saleprice,
                     saledate,
                     legalreference
                     ORDER BY 
                     uniqueid
                     ) as row_num 
FROM nashville_housing
--ORDER BY parcelid
)

SELECT *
FROM  ROWNUMCTE
WHERE row_num > 1
ORDER BY propertyaddress

--------------------------------------------------------------------------------------

--- Delete Unused Columns

SELECT * 
FROM nashville_housing;
     

ALTER TABLE  nashville_housing
DROP COLUMN owneraddress, taxdistrict, propertaddress, saledate
     
    
    
    