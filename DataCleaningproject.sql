/* 
Cleanig data with SQL 
*/

select * 
from NashvilleHousing


-----------------------------------------------------------------------------------------------------------



-- Standardize date format 

select saledate, convert(date, SaleDate) 
from NashvilleHousing ;

update NashvilleHousing 
set saledate = convert(date, SaleDate) 



-----------------------------------------------------------------------------------------------------------


-- Populate property address


select PropertyAddress
from nashvillehousing


-- where propertyaddress is null
order by parcelid, propertyaddress

select t1.ParcelID, t1.PropertyAddress, t2.ParcelID, t2.PropertyAddress, isnull(t1.PropertyAddress, t2.PropertyAddress)
from NashvilleHousing t1
join NashvilleHousing t2
on t1.ParcelID = t2.ParcelID
and t1.UniqueID <> t2.UniqueID
where t1.PropertyAddress is null


update t1
SET PropertyAddress = isnull(t1.PropertyAddress, t2.PropertyAddress)
from NashvilleHousing t1
join NashvilleHousing t2
on t1.ParcelID = t2.ParcelID
and t1.UniqueID <> t2.UniqueID
where t1.PropertyAddress is null



-----------------------------------------------------------------------------------------------------------




-- Breaking out address into individual column (Address, City, State)


select PropertyAddress
from nashvillehousing
-- where propertyaddress is null
--order by parcelid, propertyaddress

SELECT
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address ,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+ 2, len(PropertyAddress) - charindex(',', PropertyAddress)) as City

from NashvilleHousing

-- Another alternate way of doing it 

SELECT
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address ,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+2, len(PropertyAddress)) as City

from NashvilleHousing

alter table NashvilleHousing
add address varchar(100), city varchar(100)

update NashvilleHousing
set address = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1),
 city = SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+2, len(PropertyAddress))

select OwnerAddress
from NashvilleHousing

select 
PARSENAME(replace(OwnerAddress,',','.'), 3) ,
PARSENAME(replace(OwnerAddress,',','.'), 2) ,
PARSENAME(replace(OwnerAddress,',','.'), 1)
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
add OwnerSplitAddress varchar(500),
OwnerSplitCity varchar(500),
OwnerSplitState varchar(500)

UPDATE NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'), 3),
OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'), 2) ,
OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'), 1)



-----------------------------------------------------------------------------------------------------------



-- change Y and N to yes and no in the SoldAsVacant column 

select distinct(SoldAsVacant)
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = 'Yes'
where SoldAsVacant = 'Y'

UPDATE NashvilleHousing
SET SoldAsVacant = 'No'
where SoldAsVacant = 'N'



-----------------------------------------------------------------------------------------------------------


-- remove duplicates


with RowNumCTE AS
 (
select *,
ROW_NUMBER() over (partition by ParcelID, PropertyAddress, saledate, SalePrice,legalreference Order by UniqueID) as row_num
from NashvilleHousing
 )

select *
from RowNumCTE
where row_num >1 


select *
from NashvilleHousing

-----------------------------------------------------------------------------------------------------------


-- delete unused column 


ALTER TABLE NashvilleHousing
drop column PropertyAddress, OwnerAddress, TaxDistrict



-----------------------------------------------------------------------------------------------------------

-- perform trim to remove extra spaces 



UPDATE NashvilleHousing
set OwnerSplitCity = trim(OwnerSplitCity)

UPDATE NashvilleHousing
set OwnerSplitState = trim(OwnerSplitState)





