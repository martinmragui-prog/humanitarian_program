
--- statement for creating the database in case it doesnt exist
CREATE DATABASE IF NOT EXISTS humanitarian_program;

-- Table 1: beneficiary_partner_data
CREATE TABLE beneficiary_partner_data (
    partner_id        INTEGER PRIMARY KEY,
    partner           VARCHAR(30),
    village           VARCHAR(30),
    beneficiaries     INTEGER,
    beneficiary_type  VARCHAR(30)
);

-- Table 2: village_locations
CREATE TABLE village_locations (
    village_id        INTEGER PRIMARY KEY,
    village           VARCHAR(30) UNIQUE,
    latitude          VARCHAR(30),
    longitude         VARCHAR(30),
    total_population  INTEGER
);

-- Table 3: jurisdiction_hierarchy (self-referencing)
CREATE TABLE jurisdiction_hierarchy (
    id         INTEGER PRIMARY KEY,
    name       VARCHAR(50),
    type       VARCHAR(20),
    parent_id  INTEGER,
    CONSTRAINT fk_jurisdiction_parent
        FOREIGN KEY (parent_id) REFERENCES jurisdiction_hierarchy (id)
);

-- Foreign key for Table 1 (added after village_locations exists)
ALTER TABLE beneficiary_partner_data
    ADD CONSTRAINT fk_beneficiary_village
    FOREIGN KEY (village) REFERENCES village_locations (village);

INSERT INTO beneficiary_partner_data
(partner_id, partner, village, beneficiaries, beneficiary_type)
VALUES
(1, 'World Vision', 'Dharkenley', 1200, 'Individuals'),
(2, 'World Vision', 'Bulo-Kahin', 350, 'Households'),
(3, 'CARE', 'Dharkenley', 800, 'Individuals'),
(4, 'CARE', 'Hilo Kelyo', 250, 'Households'),
(5, 'IRC', 'Xubow', 1500, 'Individuals'),
(6, 'IRC', 'Xiintooy', 300, 'Households'),
(7, 'World Vision', 'Dhagax Jebis', 900, 'Individuals'),
(8, 'CARE', 'Filtare', 450, 'Households'),
(9, 'IRC', 'Howl-Wadaag', 1100, 'Individuals'),
(10, 'World Vision', 'Balcad', 700, 'Households'),
(11, 'CARE', 'Mareeray', 600, 'Individuals'),
(12, 'IRC', 'Kulmis', 400, 'Households'),
(13, 'World Vision', 'Sabuun', 1000, 'Individuals'),
(14, 'CARE', 'Bayaxaw', 500, 'Households'),
(15, 'IRC', 'Bayaxawo', 1300, 'Individuals'),
(16, 'World Vision', 'Dharkenley', 700, 'Households'),
(17, 'CARE', 'Bulo-Kahin', 550, 'Individuals'),
(18, 'IRC', 'Hilo Kelyo', 900, 'Individuals');

INSERT INTO village_locations
(village_id, village, latitude, longitude, total_population)
VALUES
(1, 'Dharkenley', '2.0469', '45.3182', 5000),
(2, 'Bulo-Kahin', '2.0560', '45.3250', 4200),
(3, 'Hilo Kelyo', '2.0650', '45.3300', 3800),
(4, 'Xubow', '2.1000', '45.3500', 6000),
(5, 'Xiintooy', '2.1100', '45.3600', 4500),
(6, 'Dhagax Jebis', '2.1200', '45.3700', 5200),
(7, 'Filtare', '2.1300', '45.3800', 3900),
(8, 'Howl-Wadaag', '2.1400', '45.3900', 4700),
(9, 'Balcad', '2.1500', '45.4000', 5500),
(10, 'Mareeray', '2.1600', '45.4100', 4300),
(11, 'Kulmis', '2.1700', '45.4200', 6058),
(12, 'Sabuun', '2.1800', '45.4300', 5100),
(13, 'Bayaxaw', '2.1900', '45.4400', 3600),
(14, 'Bayaxawo', '2.2000', '45.4500', 4000);

INSERT INTO jurisdiction_hierarchy
(id, name, type, parent_id)
VALUES
(1, 'Middle Shabelle', 'Region', NULL),
(2, 'Hiraan', 'Region', NULL),

(3, 'Balcad', 'District', 1),
(4, 'Jowhar', 'District', 1),
(5, 'Beledweyn', 'District', 2),

(6, 'Dharkenley', 'Village', 3),
(7, 'Bulo-Kahin', 'Village', 3),
(8, 'Hilo Kelyo', 'Village', 3),

(9, 'Xubow', 'Village', 4),
(10, 'Xiintooy', 'Village', 4),
(11, 'Dhagax Jebis', 'Village', 4),
(12, 'Filtare', 'Village', 4),
(13, 'Howl-Wadaag', 'Village', 4),
(14, 'Balcad', 'Village', 4),
(15, 'Mareeray', 'Village', 4),
(16, 'Kulmis', 'Village', 4),
(17, 'Sabuun', 'Village', 4),
(18, 'Bayaxaw', 'Village', 4),
(19, 'Bayaxawo', 'Village', 4);

-- =====================================================
-- TASK 1: EXPLORE THE DATA
-- =====================================================

-- 1.1 Display all records from each table

SELECT * FROM beneficiary_partner_data;
SELECT * FROM village_locations;
SELECT * FROM jurisdiction_hierarchy;

-- 1.2 Display partner, village, and beneficiaries

SELECT partner, village, beneficiaries
FROM beneficiary_partner_data;


-- 1.3 Find villages with population greater than 4,500

SELECT village, total_population
FROM village_locations
WHERE total_population > 4500;


-- 1.4 Find records where beneficiary type is Households

SELECT *
FROM beneficiary_partner_data
WHERE beneficiary_type = 'Households';

-- =====================================================
-- TASK 2: CONVERT BENEFICIARY COUNTS
-- =====================================================

SELECT
    partner,
    village,
    beneficiaries,
    beneficiary_type,
    CASE
        WHEN beneficiary_type = 'Individuals'
            THEN beneficiaries
        WHEN beneficiary_type = 'Households'
            THEN beneficiaries * 6
        ELSE 0
    END AS individual_beneficiaries
FROM beneficiary_partner_data;


-- =====================================================
-- TASK 3: PARTNER ANALYSIS
-- =====================================================

SELECT
    partner,

    SUM(
        CASE
            WHEN beneficiary_type = 'Individuals'
                THEN beneficiaries
            WHEN beneficiary_type = 'Households'
                THEN beneficiaries * 6
            ELSE 0
        END
    ) AS total_individual_beneficiaries,

    COUNT(DISTINCT village) AS villages_served,

    ROUND(AVG(
        CASE
            WHEN beneficiary_type = 'Individuals'
                THEN beneficiaries
            WHEN beneficiary_type = 'Households'
                THEN beneficiaries * 6
            ELSE 0
        END
    ), 2) AS average_individual_beneficiaries

FROM beneficiary_partner_data
GROUP BY partner
ORDER BY total_individual_beneficiaries DESC;

-- =====================================================
-- TASK 4: VILLAGE COVERAGE
-- =====================================================

SELECT
    b.partner,
    v.village,

    CASE
        WHEN b.beneficiary_type = 'Individuals'
            THEN b.beneficiaries
        WHEN b.beneficiary_type = 'Households'
            THEN b.beneficiaries * 6
        ELSE 0
    END AS individual_beneficiaries,

    v.total_population AS village_population,

    ROUND(
        100.0 *
        CASE
            WHEN b.beneficiary_type = 'Individuals'
                THEN b.beneficiaries
            WHEN b.beneficiary_type = 'Households'
                THEN b.beneficiaries * 6
            ELSE 0
        END / NULLIF(v.total_population, 0),
        2
    ) AS coverage_percentage

FROM beneficiary_partner_data b
JOIN village_locations v
    ON b.village = v.village
ORDER BY v.village, b.partner;


-- =====================================================
-- TASK 5: ADD DISTRICT INFORMATION
-- =====================================================

SELECT
    b.partner,
    b.village,
    d.name AS district,

    CASE
        WHEN b.beneficiary_type = 'Individuals'
            THEN b.beneficiaries
        WHEN b.beneficiary_type = 'Households'
            THEN b.beneficiaries * 6
        ELSE 0
    END AS individual_beneficiaries

FROM beneficiary_partner_data b

JOIN jurisdiction_hierarchy village_node
    ON village_node.name = b.village
    AND village_node.type = 'Village'

JOIN jurisdiction_hierarchy d
    ON village_node.parent_id = d.id
    AND d.type = 'District'

ORDER BY d.name, b.village, b.partner;


-- =====================================================
-- TASK 6: MULTIPLE-PARTNER VILLAGES
-- =====================================================

SELECT
    village,
    COUNT(DISTINCT partner) AS number_of_partners
FROM beneficiary_partner_data
GROUP BY village
HAVING COUNT(DISTINCT partner) > 1
ORDER BY number_of_partners DESC;

-- =====================================================
-- TASK 7A: PARTNER SUMMARY TABLE
-- =====================================================

CREATE TABLE Partner_summary AS
SELECT
    partner,

    SUM(
        CASE
            WHEN beneficiary_type = 'Individuals'
                THEN beneficiaries
            WHEN beneficiary_type = 'Households'
                THEN beneficiaries * 6
            ELSE 0
        END
    ) AS total_beneficiaries,

    COUNT(DISTINCT village) AS villages_served,

    ROUND(AVG(
        CASE
            WHEN beneficiary_type = 'Individuals'
                THEN beneficiaries
            WHEN beneficiary_type = 'Households'
                THEN beneficiaries * 6
            ELSE 0
        END
    ), 2) AS average_beneficiaries

FROM beneficiary_partner_data
GROUP BY partner;


-- View the partner summary

SELECT * FROM Partner_summary;


-- =====================================================
-- TASK 7B: DISTRICT SUMMARY TABLE
-- =====================================================

CREATE TABLE District_summary AS
SELECT
    d.name AS district,

    SUM(
        CASE
            WHEN b.beneficiary_type = 'Individuals'
                THEN b.beneficiaries
            WHEN b.beneficiary_type = 'Households'
                THEN b.beneficiaries * 6
            ELSE 0
        END
    ) AS total_individual_beneficiaries,

    COUNT(DISTINCT village_node.id) AS villages_served

FROM beneficiary_partner_data b

JOIN jurisdiction_hierarchy village_node
    ON village_node.name = b.village
    AND village_node.type = 'Village'

JOIN jurisdiction_hierarchy d
    ON village_node.parent_id = d.id
    AND d.type = 'District'

GROUP BY d.id, d.name;


-- View the district summary

SELECT * FROM District_summary;
