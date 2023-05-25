--Select * From NH

--Standardize the date format

Select Saledate, CONVERT(Date,saledate)
From NH

Alter Table NH
Add Dateofsale Date;

Update NH
Set dateofsale= CONVERT(Date,saledate)

---- 
Select *
From NH
where Propertyaddress is null

Select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
From NH a
Join dbo.NH b
on a.parcelid= b.parcelid
and a.uniqueid<> b.uniqueid
where a.propertyaddress is null


Update a
Set propertyaddress= isnull(a.propertyaddress, b.propertyaddress)
From NH a
Join dbo.NH b
on a.parcelid= b.parcelid
and a.uniqueid<> b.uniqueid
where a.propertyaddress is null

--- Breaking out address into individual columns
Select propertyaddress
from nh

Select
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as address
, SUBSTRING(Propertyaddress, CHARINDEX(',', propertyaddress) +1, Len(Propertyaddress))as address
from NH

Alter table NH
Add Propertyspiltaddress Nvarchar(255)

Update NH
Set propertyspiltaddress= SUBSTRING(Propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

Alter table NH
Add Propertyspiltcity Nvarchar(255)

Update NH
Set propertyspiltcity= SUBSTRING(Propertyaddress, CHARINDEX(',', propertyaddress) +1, Len(Propertyaddress))

Select owneraddress
from NH

Select
PARSENAME(replace(Owneraddress, ',', '.'),3),
PARSENAME(replace(Owneraddress, ',', '.'),2),
PARSENAME(replace(Owneraddress, ',', '.'),1)
From NH

Alter Table NH
Add owneraddressa Nvarchar(250)

Update NH 
set owneraddressa= PARSENAME(replace(Owneraddress, ',', '.'),3)

Alter Table NH
Add ownercity Nvarchar(250)
Update NH 
set ownercity= PARSENAME(replace(Owneraddress, ',', '.'),2)

Alter Table NH
Add ownerstate Nvarchar(250)
Update NH 
set ownerstate= PARSENAME(replace(Owneraddress, ',', '.'),1)


---Change Y AND N TO YES AND NO
Select distinct(soldasvacant), count(soldasvacant)
from nh
Group by SoldAsVacant
order by 2

Select soldasvacant
, case when soldasvacant = 'y'Then 'Yes'
when soldasvacant= 'N' then 'No'
Else SoldAsVacant
End
From NH

Update NH 
set soldasvacant= case when soldasvacant = 'y'Then 'Yes'
when soldasvacant= 'N' then 'No'
Else SoldAsVacant
End

---removing duplicates
With RownmCTE AS (
select*,
      Row_Number() over (
	  partition by parcelid, propertyaddress, saleprice, saledate, legalreference
	  order by uniqueid) row_nm
	  from nh)

	  Select* from RownmCTE
	  where row_nm> 1
	   
---delete unused columns
select * from nh

alter table nh
drop column saledate

select* from nh

 




















