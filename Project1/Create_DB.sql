CREATE DATABASE Project_1

CREATE TABLE Nike(
    nike_id INT IDENTITY NOT NULL,
    Date DATETIME NOT NULL,
    "Open" FLOAT NOT NUll,
    High FLOAT NOT NULL,
    Low FLOAT NOT NULL,
    "Close" FLOAT NOT NULL,
    Volume FLOAT NOT NULL,
    VWAP FLOAT NOT NULL,
    Transactions INT NOT NULL,
    "Percent Change" DECIMAL(6,5) NOT NULL,
    "Return" FLOAT NOT NULL
    PRIMARY KEY(nike_id)
)

CREATE TABLE Spotify(
    spotify_id INT IDENTITY NOT NULL,
    Date DATETIME NOT NULL,
    "Open" FLOAT NOT NUll,
    High FLOAT NOT NULL,
    Low FLOAT NOT NULL,
    "Close" FLOAT NOT NULL,
    Volume FLOAT NOT NULL,
    VWAP FLOAT NOT NULL,
    Transactions INT NOT NULL,
    "Percent Change" DECIMAL(6,5) NOT NULL,
    "Return" FLOAT NOT NULL
    PRIMARY KEY(spotify_id)
)

CREATE TABLE Decker(
    decker_id INT IDENTITY NOT NULL,
    Date DATETIME NOT NULL,
    "Open" FLOAT NOT NUll,
    High FLOAT NOT NULL,
    Low FLOAT NOT NULL,
    "Close" FLOAT NOT NULL,
    Volume FLOAT NOT NULL,
    VWAP FLOAT NOT NULL,
    Transactions INT NOT NULL,
    "Percent Change" DECIMAL(6,5) NOT NULL,
    "Return" FLOAT NOT NULL
    PRIMARY KEY(decker_id)
)

CREATE TABLE ETF(
    etf_id INT IDENTITY NOT NULL,
    Date DATETIME NOT NULL,
    "Open" FLOAT NOT NUll,
    High FLOAT NOT NULL,
    Low FLOAT NOT NULL,
    "Close" FLOAT NOT NULL,
    Volume FLOAT NOT NULL,
    VWAP FLOAT NOT NULL,
    Transactions INT NOT NULL,
    "Percent Change" DECIMAL(6,5) NOT NULL,
    "Return" FLOAT NOT NULL
    PRIMARY KEY(etf_id)
)

CREATE TABLE Forex(
    forex_id INT IDENTITY NOT NULL,
    Date DATETIME NOT NULL,
    "Open" FLOAT NOT NUll,
    High FLOAT NOT NULL,
    Low FLOAT NOT NULL,
    "Close" FLOAT NOT NULL,
    Volume FLOAT NOT NULL,
    VWAP FLOAT NOT NULL,
    Transactions INT NOT NULL,
    "Percent Change" DECIMAL(6,5) NOT NULL,
    "Return" FLOAT NOT NULL
    PRIMARY KEY(forex_id)
)

CREATE TABLE Daily_Returns(
    return_id INT IDENTITY NOT NULL,
    Date DATETIME NOT NULL,
    "Return Forex" FLOAT NOT NULL,
    "Return ETF" FLOAT NOT NULL,
    "Return Nike" FLOAT NOT NULL,
    "Return Deckers" FLOAT NOT NULL,
    "Return Spotify" FLOAT NOT NULL,
    "Total Returns" FLOAT NOT NULL
    PRIMARY KEY(return_id)
)

CREATE TABLE NDX(
    ndx_id INT IDENTITY NOT NULL,
    "Date" DATETIME NOT NULL,
    "Close" FLOAT NOT NULL,
    "Open" FLOAT NOT NULL,
    "High" FLOAT NOT NULL,
    "Low" FLOAT NOT NULL,
    "Percent Change" FLOAT NOT NULL
    PRIMARY KEY(ndx_id)
)

BULK INSERT Nike FROM '/media/Nike_Table.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) 
BULK INSERT Spotify FROM '/media/Spotify_Table.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) 
BULK INSERT Decker FROM '/media/Decker_Table.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2)
BULK INSERT ETF FROM '/media/ETF_Table.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) 
BULK INSERT Forex FROM '/media/Forex_Table.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2)  
BULK INSERT Daily_Returns FROM '/media/Returns.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) 
BULK INSERT NDX FROM '/media/NDX_Table.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2)   

SELECT * FROM NDX