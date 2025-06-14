-- Question 1 a. Which prescriber had the highest total number of claims (totaled over all drugs)? 
--Report the npi and the total number of claims.
SELECT npi, SUM(total_claim_count)
FROM prescription
GROUP BY npi
ORDER BY SUM(total_claim_count) DESC

--Answer: 1881634483,	99707 claims
--b.  Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, 
--specialty_description, and the total number of claims.

SELECT p.nppes_provider_first_name,p.nppes_provider_last_org_name,p.specialty_description, total_claim_count
FROM prescription 
INNER JOIN prescriber AS p
ON prescription.npi=p.npi
ORDER BY total_claim_count DESC

--ANSWER: "DAVID"	"COFFEY"	"Family Practice"	4538 total claims

--Question 2 a. Which specialty had the most total number of claims (totaled over all drugs)?

SELECT p.specialty_description, SUM(total_claim_count)
FROM prescription
INNER JOIN prescriber AS p
ON prescription.npi = p.npi
GROUP BY p.specialty_description
ORDER BY  SUM(total_claim_count) DESC;
--ANSWER: "Family Practice",	9752347 total claims

--b. Which specialty had the most total number of claims for opioids?
SELECT p.specialty_description, SUM(total_claim_count), drug.opioid_drug_flag
FROM prescription
INNER JOIN prescriber AS p
ON prescription.npi=p.npi
INNER JOIN drug
ON prescription.drug_name = drug.drug_name
WHERE opioid_drug_flag ='Y'
GROUP BY p.specialty_description,  drug.opioid_drug_flag
ORDER BY SUM(total_claim_count) DESC
--ANSWER: Nurse PRactitioner

--c. Challenge Question: Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

--d. Difficult Bonus: Do not attempt until you have solved all other problems! For each specialty, report the percentage of total claims by that specialty which are for opioids. 
--Which specialties have a high percentage of opioids?

--QUESTION 3 a. Which drug (generic_name) had the highest total drug cost?
SELECT d.generic_name, SUM(p.total_drug_cost)
FROM drug AS d
INNER JOIN prescription AS p
USING (drug_name)
GROUP BY d.generic_name
ORDER BY SUM(p.total_drug_cost) DESC

--ANSWER: "INSULIN GLARGINE,HUM.REC.ANLOG"

--b. Which drug (generic_name) has the hightest total cost per day? 
--Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.

SELECT d.generic_name, ROUND(SUM(p.total_drug_cost)/SUM (p.total_day_supply),2) AS total_daily
FROM prescription AS p
INNER JOIN drug AS d
USING (drug_name)
GROUP BY d.generic_name
ORDER BY total_daily DESC

--Answer: "C1 ESTERASE INHIBITOR"

-- Question 4: For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' 
--for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.
SELECT drug_name,
CASE 
    WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither' END AS drug_type
FROM drug

--b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. 
--Hint: Format the total costs as MONEY for easier comparision.

SELECT 
CASE 
    WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither' END AS drug_type
	,CAST(SUM (p.total_drug_cost)AS money)AS total_cost
FROM drug
INNER JOIN prescription AS p
USING (drug_name)
GROUP BY drug_type
ORDER BY  total_cost DESC

--ANSWER: "opioid"	"$105,080,626.37"

-- QUESTION 5 a. How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.
SELECT DISTINCT (cbsaname)
FROM cbsa
WHERE cbsaname iLIKE '%TN';

--ANSWER:6

--b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
SELECT c.cbsaname, SUM (p.population)
FROM cbsa as c
INNER JOIN population as p
USING (fipscounty)
GROUP BY c.cbsaname
ORDER BY SUM (p.population) DESC;
--ORDER BY SUM (p.population) 

--ANSWER: cbsa name: "Nashville-Davidson--Murfreesboro--Franklin,TN" with a largest total population of 1830410 
-- and cbsa name:Morristown,TN with smallest population of 116352

--c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
 SELECT county,SUM (p.population)
 FROM fips_county
 INNER JOIN  population as p
 USING (fipscounty)
 GROUP BY county
 ORDER BY SUM (p.population) DESC;

 -- ANSWER: SHELBY county, with a population of	937847
 
--QUESTION 6 a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

SELECT drug_name, SUM(total_claim_count) AS total_claim
FROM prescription
WHERE total_claim_count > 3000
GROUP by drug_name
ORDER BY total_claim;

-- b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
SELECT drug_name, SUM(total_claim_count) AS total_claim,
CASE 
   WHEN
FROM prescription
WHERE total_claim_count > 3000
GROUP by drug_name
ORDER BY total_claim;