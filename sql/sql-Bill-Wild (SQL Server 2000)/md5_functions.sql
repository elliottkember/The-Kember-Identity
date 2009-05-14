

/* Create the log table */
CREATE TABLE [dbo].[tabMD5] (
	[attempt_id] [bigint] IDENTITY (1, 1) NOT NULL ,
	[attempt_verbiage] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[attempt_timestamp] [datetime] NULL 
) ON [PRIMARY]
GO


--////////////////////////////////////////
--//Create some useful Utility functions
--////////////////////////////////////////

---Submitted By : Nayan Patel
--http://binaryworld.net/Main/CodeDetail.aspx?CodeId=3600

-- Converts binary(4) into integer.
CREATE FUNCTION dbo.md5_bin2int
(@x BINARY(4))
RETURNS INT
BEGIN
   RETURN CONVERT(INT, SUBSTRING(@x, 4, 1) + SUBSTRING(@x, 3, 1) + SUBSTRING(@x, 2, 1) + SUBSTRING(@x, 1, 1))
END
GO

--Converts integer into binary(4)
CREATE FUNCTION dbo.md5_int2bin
(@x INT)
RETURNS BINARY(4)
BEGIN
   RETURN SUBSTRING(CONVERT(BINARY(4), @x), 4, 1) + SUBSTRING(CONVERT(BINARY(4), @x), 3, 1) + SUBSTRING(CONVERT(BINARY(4), @x), 2, 1) + SUBSTRING(CONVERT(BINARY(4), @x), 1, 1)
END
GO

-- Rotate bits left
CREATE FUNCTION dbo.md5_bitrol
(
@x INT,
@s INT
)
RETURNS INT

BEGIN
   RETURN CONVERT(INT,SUBSTRING(CONVERT(BINARY(8), CONVERT(BIGINT, CONVERT(BINARY(4), @x)) * POWER(2, @s)), 5, 4)) | CONVERT(INT,SUBSTRING(CONVERT(BINARY(8), CONVERT(BIGINT, CONVERT(BINARY(4), @x)) / POWER(2, 32 - @s)), 5, 4))
END
GO

-- Add two unsigned integers
CREATE FUNCTION dbo.md5_add
(
@a INT,
@b INT
)
RETURNS INT
BEGIN
   RETURN CONVERT(INT, SUBSTRING(CONVERT(VARBINARY, CONVERT(BIGINT, @a) + CONVERT(BIGINT, @b)), 5, 4))
END
GO

-- MD5 ff transformation
CREATE FUNCTION dbo.md5_ff
(
@a INT,
@b INT,
@c INT,
@d INT,
@x INT,
@s INT,
@t INT
)
RETURNS INT
BEGIN
   RETURN dbo.md5_add(dbo.md5_bitrol(dbo.md5_add(dbo.md5_add(@a, (@b & @c) | ((~@b) & @d)), dbo.md5_add(@x, @t)), @s),@b)
END
GO

-- MD5 gg transformation
CREATE FUNCTION dbo.md5_gg
(
@a INT,
@b INT,
@c INT,
@d INT,
@x INT,
@s INT,
@t INT
)
RETURNS INT
BEGIN
   RETURN dbo.md5_add(dbo.md5_bitrol(dbo.md5_add(dbo.md5_add(@a, (@b & @d) | (@c & (~@d))), dbo.md5_add(@x, @t)), @s),@b)
END
GO

-- MD5 hh transformation
CREATE FUNCTION dbo.md5_hh
(
@a INT,
@b INT,
@c INT,
@d INT,
@x INT,
@s INT,
@t INT
)
RETURNS INT
BEGIN
   RETURN dbo.md5_add(dbo.md5_bitrol(dbo.md5_add(dbo.md5_add(@a, @b ^ @c ^ @d), dbo.md5_add(@x, @t)), @s),@b)
END
GO

-- MD5 ii transformation
CREATE FUNCTION dbo.md5_ii
(
@a INT,
@b INT,
@c INT,
@d INT,
@x INT,
@s INT,
@t INT
)
RETURNS INT
BEGIN
   RETURN dbo.md5_add(dbo.md5_bitrol(dbo.md5_add(dbo.md5_add(@a, @c ^ (@b | (~@d))), dbo.md5_add(@x, @t)), @s),@b)
END
GO


/********************************************************************************
Calculate the MD5 hash of @Data.

Adapted by Barry McAuslin from the RSA Data Security, Inc. MD5 Message-Digest
Algorithm for SQL Server 2000

Download from www.sqlfe.com

Copyright (C) 1991-2, RSA Data Security, Inc. Created 1991. All
rights reserved.

License to copy and use this software is granted provided that it
is identified as the "RSA Data Security, Inc. MD5 Message-Digest
Algorithm" in all material mentioning or referencing this software
or this function.

License is also granted to make and use derivative works provided
that such works are identified as "derived from the RSA Data
Security, Inc. MD5 Message-Digest Algorithm" in all material
mentioning or referencing the derived work.

RSA Data Security, Inc. makes no representations concerning either
the merchantability of this software or the suitability of this
software for any particular purpose. It is provided "as is"
without express or implied warranty of any kind.

These notices must be retained in any copies of any part of this
documentation and/or software.
********************************************************************************/
CREATE FUNCTION dbo.MD5
(
@Data VARBINARY(8000)
)
RETURNS BINARY(16)
BEGIN

DECLARE @Len INT    -- Length of data
DECLARE @i INT        -- Counter

DECLARE @a INT        -- First word of hash
DECLARE @b INT        -- Second word of hash
DECLARE @c INT        -- Third word of hash
DECLARE @d INT        -- Fourth word of hash
DECLARE @olda INT
DECLARE @oldb INT
DECLARE @oldc INT
DECLARE @oldd INT

-- 16 words in 64 byte block
DECLARE @c0 INT
DECLARE @c1 INT
DECLARE @c2 INT
DECLARE @c3 INT
DECLARE @c4 INT
DECLARE @c5 INT
DECLARE @c6 INT
DECLARE @c7 INT
DECLARE @c8 INT
DECLARE @c9 INT
DECLARE @c10 INT
DECLARE @c11 INT
DECLARE @c12 INT
DECLARE @c13 INT
DECLARE @c14 INT
DECLARE @c15 INT

-- Null returns null. Zero length byte string return a hash.
IF @Data IS NULL RETURN NULL

-- Find length and append 1 bit, padding, and length
SET @Len = DATALENGTH(@Data)
SET @Data = @Data + (0x80 + CONVERT(VARBINARY(64), REPLICATE(CHAR(0), (64 - ((@Len + 9)% 64)) % 64)) + dbo.md5_int2bin(@Len * 8) + 0x00000000)
SET @Len = DATALENGTH(@Data)

-- Initialise hash values
SET @a = 1732584193
SET @b = -271733879
SET @c = -1732584194
SET @d = 271733878

SET @i = 1

-- Loop through each 16 words or 64 bytes
WHILE @i <= @Len
   BEGIN

   SET @olda = @a
   SET @oldb = @b
   SET @oldc = @c
   SET @oldd = @d

   -- Get word values for the 64 byte block
   SET @c0 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 0, 4))
   SET @c1 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 4, 4))
   SET @c2 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 8, 4))
   SET @c3 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 12, 4))
   SET @c4 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 16, 4))
   SET @c5 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 20, 4))
   SET @c6 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 24, 4))
   SET @c7 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 28, 4))
   SET @c8 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 32, 4))
   SET @c9 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 36, 4))
   SET @c10 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 40, 4))
   SET @c11 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 44, 4))
   SET @c12 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 48, 4))
   SET @c13 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 52, 4))
   SET @c14 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 56, 4))
   SET @c15 = dbo.md5_bin2int(SUBSTRING(@Data, @i + 60, 4))


   -- Perform FF transformations
   SET @a = dbo.md5_ff(@a, @b, @c, @d, @c0, 7 , -680876936);
   SET @d = dbo.md5_ff(@d, @a, @b, @c, @c1, 12, -389564586);
   SET @c = dbo.md5_ff(@c, @d, @a, @b, @c2, 17, 606105819);
   SET @b = dbo.md5_ff(@b, @c, @d, @a, @c3, 22, -1044525330);
   SET @a = dbo.md5_ff(@a, @b, @c, @d, @c4, 7 , -176418897);
   SET @d = dbo.md5_ff(@d, @a, @b, @c, @c5, 12, 1200080426);
   SET @c = dbo.md5_ff(@c, @d, @a, @b, @c6, 17, -1473231341);
   SET @b = dbo.md5_ff(@b, @c, @d, @a, @c7, 22, -45705983);
   SET @a = dbo.md5_ff(@a, @b, @c, @d, @c8, 7 , 1770035416);
   SET @d = dbo.md5_ff(@d, @a, @b, @c, @c9, 12, -1958414417);
   SET @c = dbo.md5_ff(@c, @d, @a, @b, @c10, 17, -42063);
   SET @b = dbo.md5_ff(@b, @c, @d, @a, @c11, 22, -1990404162);
   SET @a = dbo.md5_ff(@a, @b, @c, @d, @c12, 7 , 1804603682);
   SET @d = dbo.md5_ff(@d, @a, @b, @c, @c13, 12, -40341101);
   SET @c = dbo.md5_ff(@c, @d, @a, @b, @c14, 17, -1502002290);
   SET @b = dbo.md5_ff(@b, @c, @d, @a, @c15, 22, 1236535329);


   -- Perform GG transformations
   SET @a = dbo.md5_gg(@a, @b, @c, @d, @c1, 5 , -165796510);
   SET @d = dbo.md5_gg(@d, @a, @b, @c, @c6, 9 , -1069501632);
   SET @c = dbo.md5_gg(@c, @d, @a, @b, @c11, 14, 643717713);
   SET @b = dbo.md5_gg(@b, @c, @d, @a, @c0, 20, -373897302);
   SET @a = dbo.md5_gg(@a, @b, @c, @d, @c5, 5 , -701558691);
   SET @d = dbo.md5_gg(@d, @a, @b, @c, @c10, 9 , 38016083);
   SET @c = dbo.md5_gg(@c, @d, @a, @b, @c15, 14, -660478335);
   SET @b = dbo.md5_gg(@b, @c, @d, @a, @c4, 20, -405537848);
   SET @a = dbo.md5_gg(@a, @b, @c, @d, @c9, 5 , 568446438);
   SET @d = dbo.md5_gg(@d, @a, @b, @c, @c14, 9 , -1019803690);
   SET @c = dbo.md5_gg(@c, @d, @a, @b, @c3, 14, -187363961);
   SET @b = dbo.md5_gg(@b, @c, @d, @a, @c8, 20, 1163531501);
   SET @a = dbo.md5_gg(@a, @b, @c, @d, @c13, 5, -1444681467);
   SET @d = dbo.md5_gg(@d, @a, @b, @c, @c2, 9, -51403784);
   SET @c = dbo.md5_gg(@c, @d, @a, @b, @c7, 14, 1735328473);
   SET @b = dbo.md5_gg(@b, @c, @d, @a, @c12, 20, -1926607734);


   -- Perform HH transformations
   SET @a = dbo.md5_hh(@a, @b, @c, @d, @c5, 4 , -378558);
   SET @d = dbo.md5_hh(@d, @a, @b, @c, @c8, 11, -2022574463);
   SET @c = dbo.md5_hh(@c, @d, @a, @b, @c11, 16, 1839030562);
   SET @b = dbo.md5_hh(@b, @c, @d, @a, @c14, 23, -35309556);
   SET @a = dbo.md5_hh(@a, @b, @c, @d, @c1, 4 , -1530992060);
   SET @d = dbo.md5_hh(@d, @a, @b, @c, @c4, 11, 1272893353);
   SET @c = dbo.md5_hh(@c, @d, @a, @b, @c7, 16, -155497632);
   SET @b = dbo.md5_hh(@b, @c, @d, @a, @c10, 23, -1094730640);
   SET @a = dbo.md5_hh(@a, @b, @c, @d, @c13, 4 , 681279174);
   SET @d = dbo.md5_hh(@d, @a, @b, @c, @c0, 11, -358537222);
   SET @c = dbo.md5_hh(@c, @d, @a, @b, @c3, 16, -722521979);
   SET @b = dbo.md5_hh(@b, @c, @d, @a, @c6, 23, 76029189);
   SET @a = dbo.md5_hh(@a, @b, @c, @d, @c9, 4 , -640364487);
   SET @d = dbo.md5_hh(@d, @a, @b, @c, @c12, 11, -421815835);
   SET @c = dbo.md5_hh(@c, @d, @a, @b, @c15, 16, 530742520);
   SET @b = dbo.md5_hh(@b, @c, @d, @a, @c2, 23, -995338651);


   -- Perform II transformations
   SET @a = dbo.md5_ii(@a, @b, @c, @d, @c0, 6 , -198630844);
   SET @d = dbo.md5_ii(@d, @a, @b, @c, @c7, 10, 1126891415);
   SET @c = dbo.md5_ii(@c, @d, @a, @b, @c14, 15, -1416354905);
   SET @b = dbo.md5_ii(@b, @c, @d, @a, @c5, 21, -57434055);
   SET @a = dbo.md5_ii(@a, @b, @c, @d, @c12, 6 , 1700485571);
   SET @d = dbo.md5_ii(@d, @a, @b, @c, @c3, 10, -1894986606);
   SET @c = dbo.md5_ii(@c, @d, @a, @b, @c10, 15, -1051523);
   SET @b = dbo.md5_ii(@b, @c, @d, @a, @c1, 21, -2054922799);
   SET @a = dbo.md5_ii(@a, @b, @c, @d, @c8, 6 , 1873313359);
   SET @d = dbo.md5_ii(@d, @a, @b, @c, @c15, 10, -30611744);
   SET @c = dbo.md5_ii(@c, @d, @a, @b, @c6, 15, -1560198380);
   SET @b = dbo.md5_ii(@b, @c, @d, @a, @c13, 21, 1309151649);
   SET @a = dbo.md5_ii(@a, @b, @c, @d, @c4, 6 , -145523070);
   SET @d = dbo.md5_ii(@d, @a, @b, @c, @c11, 10, -1120210379);
   SET @c = dbo.md5_ii(@c, @d, @a, @b, @c2, 15, 718787259);
   SET @b = dbo.md5_ii(@b, @c, @d, @a, @c9, 21, -343485551);


   SET @a = dbo.md5_add(@a, @olda)
   SET @b = dbo.md5_add(@b, @oldb)
   SET @c = dbo.md5_add(@c, @oldc)
   SET @d = dbo.md5_add(@d, @oldd)

   SET @i = @i + 64
   END
   
   RETURN dbo.md5_int2bin(@a) + dbo.md5_int2bin(@b) + dbo.md5_int2bin(@c) + dbo.md5_int2bin(@d)

END

GO

GRANT EXECUTE ON dbo.MD5 TO public

GO