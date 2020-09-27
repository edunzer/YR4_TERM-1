SELECT CardNumber, Len(CardNumber) AS CardLen, RIGHT(CardNumber,4) AS LastFourDigit, CONCAT('XXXX-XXXX-XXXX-',RIGHT(CardNumber,4)) AS FormatedNumber
FROM Orders