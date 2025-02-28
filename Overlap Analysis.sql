WITH step_one AS(
SELECT 
a.oclcnumber,
MAX(CoverageEnd) AS GaleBi_CoverageEnd,
comparison_endDate 
FROM GaleBI_25 a
LEFT JOIN(
		SELECT oclc_number, MAX(enddate) AS comparison_endDate FROM oclc_fulltext_fy25_detail GROUP BY oclc_number
) b
ON a.oclcnumber = b.oclc_number
WHERE a.content = 'fulltext journal'
GROUP BY 1,3
ORDER BY 1)

SELECT *,
	CASE
		WHEN GaleBi_CoverageEnd >= comparison_enddate THEN 1 ELSE 0 END AS CoverageAdvantage,
	SUM(CASE WHEN GaleBi_CoverageEnd >= comparison_enddate THEN 1 ELSE 0 END) OVER() AS currentAdvantage,
	SUM(CASE WHEN GaleBi_CoverageEnd >= comparison_enddate THEN 0 ELSE 1 END) OVER() AS GaleAdvantage
FROM step_one
WHERE comparison_enddate IS NOT NULL;