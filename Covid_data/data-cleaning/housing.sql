drop table housing
create table housing(
UniqueID integer,
ParcelID varchar(25),
LandUse varchar(50),
PropertyAddress varchar(50),
SaleDate date,
SalePrice numeric,
LegalReference varchar(25),
SoldAsVacant varchar(5),
OwnerName varchar(255),
OwnerAddress varchar(255),
Acreage	numeric,
TaxDistrict varchar(50),
LandValue numeric,
BuildingValue numeric,
TotalValue numeric,
YearBuilt numeric,
Bedrooms numeric,
FullBath numeric,
HalfBath numeric
)

ALTER TABLE housing ADD CONSTRAINT uniqueId UNIQUE (UniqueID)

COPY housing
FROM '/tmp/Nashville Housing Data for Data Cleaning.csv'
WITH (FORMAT CSV, HEADER);

select *
from housing

