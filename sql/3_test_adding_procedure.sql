
DECLARE @VarOrderType AS OrderType
 
INSERT INTO @VarOrderType
VALUES (
        'USCA'   , 
       'United States'   ,
       'Oklahoma'   ,
        'Oklahoma City'   ,
       '73120'     ,
        'AB-100151402'   ,
       'Aaron Bergman'   ,
        'Consumer'   ,
        'CA-2014-AB10015140-41954'   ,
        '2014-11-11'   ,
      '2014-11-13'   ,
        'First Class'   ,
        'Furniture'   ,
        'Bookcases'   ,
       'FUR-BO-5957'   ,
        'Sauder Facets Collection Library, Sky Alder Finish'   ,
        2,
        341.96,
        0.01,
       25.27,
        54.71)

INSERT INTO @VarOrderType
VALUES (
        'USCA'   , 
       'United States'   ,
       'Oklahoma'   ,
        'Oklahoma City'   ,
       '73120'     ,
        'AB-100151402'   ,
       'Aaron Bergman'   ,
        'Consumer'   ,
        'CA-2014-AB10015140-41954'   ,
        '2014-11-11'   ,
      '2014-11-13'   ,
        'First Class'   ,
        'Technology'   ,
        'Phones'   ,
       'TEC-PH-5816'   ,
        'Samsung Convoy 3'   ,
        2,
        221.96,
        0,
       40.77,
        62.15)

INSERT INTO @VarOrderType
VALUES (
        'Asia Pacific'   , 
       'Afghanistan'   ,
       'Kabul'   ,
        'Kabul'   ,
        NULL     ,
        'AJ-107801'   ,
       'Anthony Jacobs'   ,
        'Corporate'   ,
        'ID-2013-AJ107801-41383'   ,
        '2014-04-19'   ,
      '2014-04-22'   ,
        'First Class'   ,
        'Furniture'   ,
        'Tables'   ,
       'FUR-TA-3420'   ,
        'Bevis Conference Table, Fully Assembled'   ,
        5,
        4626.15,
        0,
       835.57,
        647.55)



EXECUTE addorders @VarOrderType
