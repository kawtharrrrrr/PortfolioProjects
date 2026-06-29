  select * 
  from [Portfolio Project].dbo.[Nashville Housing]

  --cleaning data
  
  update 

  alter 
  alter

  --date format nvarch to date

  select SaleDate ,CONVERT(date,saledate)
  from [Portfolio Project].dbo.[Nashville Housing]

  update [Portfolio Project].dbo.[Nashville Housing]
  set saledate = CONVERT(date,saledate)
 
  --

  select *
  from [Portfolio Project].dbo.[Nashville Housing]
  --where PropertyAddress is null
  order by ParcelID

--ربط الجدول ببعضه 

  select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,isnull(a.propertyaddress,b.PropertyAddress)
  from [Portfolio Project].dbo.[Nashville Housing] a
  join [Portfolio Project].dbo.[Nashville Housing] b
  on a.parcelid = b.ParcelID 
  and a.UniqueID <> b.UniqueID


  update a
  set propertyaddress = isnull(a.propertyaddress,b.PropertyAddress)
  from [Portfolio Project].dbo.[Nashville Housing] a
  join [Portfolio Project].dbo.[Nashville Housing] b
  on a.parcelid = b.ParcelID 
  and a.UniqueID <> b.UniqueID
    where a.PropertyAddress is null

    
  select *
from [Portfolio Project].dbo.[Nashville Housing]
where PropertyAddress is null

--breaking out address into indivdual columns (address,city,state)

select
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1) as city 
from [Portfolio Project].dbo.[Nashville Housing]

alter table [Portfolio Project].dbo.[Nashville Housing]
add PropertysplitAddress nvarchar(225)

alter table [Portfolio Project].dbo.[Nashville Housing]
add Propertysplitcity nvarchar(225)

update [Portfolio Project].dbo.[Nashville Housing]
set PropertysplitAddress = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

update [Portfolio Project].dbo.[Nashville Housing]
set Propertysplitcity = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1) 

--owner address
 
 select 
 owneraddress,
 SUBSTRING(OWNERADDRESS,1,CHARINDEX(',',OWNERADDRESS)-1),
 SUBSTRING(OWNERADDRESS,CHARINDEX(',',OWNERADDRESS)+1),
 CHARINDEX(',',OWNERADDRESS)
 from [Portfolio Project].DBO.[Nashville Housing]

 ALTER TABLE [Portfolio Project].DBO.[Nashville Housing]
 add ownersplitaddress nvarchar(225)

  ALTER TABLE [Portfolio Project].DBO.[Nashville Housing]
 add ownersplitcity nvarchar(225)

 update [Portfolio Project].DBO.[Nashville Housing]
 set ownersplitaddress = SUBSTRING(OWNERADDRESS,1,CHARINDEX(',',OWNERADDRESS)-1)

  update [Portfolio Project].DBO.[Nashville Housing]
 set ownersplitcity = SUBSTRING(OWNERADDRESS,CHARINDEX(',',OWNERADDRESS)+1)


 alter table [Portfolio Project].DBO.[Nashville Housing]
 add state nvarchar (225)
   
   update [Portfolio Project].DBO.[Nashville Housing]
 set state = PARSENAME(replace(owneraddress,',','.'),1)

   
 alter table [Portfolio Project].dbo.[Nashville Housing]
 drop column ownersplitcity
   
    alter table [Portfolio Project].DBO.[Nashville Housing]
 add owneraddress nvarchar (225)
   
   update [Portfolio Project].DBO.[Nashville Housing]
 set owneraddress = PARSENAME(replace(owneraddress,',','.'),2)

   select * 
  from [Portfolio Project].dbo.[Nashville Housing]

  --change 1 and 0 to yes and no
  
  select distinct(soldasvacant),count(soldasvacant)
  from [Portfolio Project].dbo.[Nashville Housing]
  group by soldasvacant
  
  alter table [Portfolio Project].dbo.[Nashville Housing]
  alter column soldasvacant nvarchar(3)

    select soldasvacant,
    case 
    when soldasvacant = '0' then 'NO'
    when soldasvacant = '1' then 'YES'
    else soldasvacant end
  from [Portfolio Project].dbo.[Nashville Housing]

 update [Portfolio Project].dbo.[Nashville Housing]
  set soldasvacant =   case 
    when soldasvacant = '0' then 'NO'
    when soldasvacant = '1' then 'YES'
    else soldasvacant end

    --remove duplicates

    with rownumcte as(
    select *, 
    ROW_NUMBER() over(
    partition by parcelid,
                 propertyaddress,  
                 saleprice,
                 saledate,
                 legalreference
                 order by 
                 uniqueID
                 ) row_num

      from [Portfolio Project].dbo.[Nashville Housing]

      )
    --select *
    --  from rownumcte
    --  where row_num > 1
     
     delete 
      from rownumcte
      where row_num > 1

      --delere unused column 

       select * 
  from [Portfolio Project].dbo.[Nashville Housing]

  alter table [Portfolio Project].dbo.[Nashville Housing]
  drop column owneraddress,taxdistrict,propertyaddress

  
  alter table [Portfolio Project].dbo.[Nashville Housing]
  drop column saledate