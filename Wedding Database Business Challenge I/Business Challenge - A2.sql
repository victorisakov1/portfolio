 /*
	TEAM 6 - Business Challenge - Client Proposals
	
    When defining vendors into groups we based it on our required elements (direct elements) as the highest priority, 
 and if possible adding inferred elements as the second priority. Our relevant vendors were chosen using those criterias 
 and other vendors were dismissed from the relevant_vendors table. 
	In addition, the wedding_size column was defined if the vendor is able to serve: 
1-50 people (and difined by letter "s")
51-150 people (and difined by letter "m")
151+ people (and defined by letter "l"), 
where combinations of letters together means that vendor can serve other size of weddings as well. It helped us to calculate 
estimated budget in the vendor_options table due to some vendors serving a product/service per 1 person. 
In our case, after analyzing vendors in the database and their related websites, most vendors can serve all wedding sizes, 
whereas some specific vendors have limits (due to lack of experience or lack of small/medium/large events in their past events.
    Regarding the budget_level, vendors that serve various types of services/products, that could be defined as 
inexpensive ("i"), affordable("a"), moderate("m"), and luxury("l"), have either one or more letters, which follow same logic
as the wedding_size. Some vendors had relevant price ranges within the wedding_database, and for others we had to access their 
websites to understand which price category the vendors related to.
	As a result, relevant_vendors table has only vendors that can satisfy customer needs and wants, and provide them with various 
budget levels further.
	
    In the vendor_options table, we had some vendor reperitions dut to the importance of some of our client's requirements.
For example, venue option stays the same throughout all options due to being the only choice that satisfies customer's desires.
Also, some vendors had repetitions because they satisfied vision board direct elements but were limited within a Moderate or Luxury 
budget level (like catering vendors). We dicided that our clients direct elements are very important to them, so a higher price range
might be worth it to bring a greater value for a "one in a lifetime" event - their Wedding!
    Based on the importance of certain departments in our vision board, we defined some vendors' requirements with extra care,
so we can provide the best service and improve customer satisfaction. 
	Overall, most of our choices were made based on how well vendors will create a wedding that our customers described through
images. Budget was estimated very carefully and is very detailed. With some vendors it is based on the ranges within the departments
budget levels, and for others - we used website information to estimate the final costs.
 */ 

-- Starting with the USE statement to access wedding_database
USE wedding_database;

-- need to drop table relevant_vendors if it already exists
DROP TABLE IF EXISTS relevant_vendors;

-- now is the time to create our first temporary table: relevant_vendors
CREATE TEMPORARY TABLE relevant_vendors AS (

-- Filtering all relevant Venues:
SELECT DISTINCT(vendor_name), vendor_depart, vendor_location,
CASE
	WHEN 	v.vendor_name LIKE 'half moon bay golf links%' 	
			THEN "sml" -- then assigning a size to it
END AS 	wedding_size,
CASE 
	WHEN 	v.vendor_name LIKE 'half moon bay golf links%'  
			THEN "iaml" -- assigning a budget to it
END AS  budget_level

FROM vendors AS v
JOIN products AS p -- Joining products and vendors 
ON v.vendor_id = p.vendor_id
JOIN ven_settings AS v2 -- Also joining ven_settings
ON p.product_id = v2.product_id
WHERE v.vendor_id LIKE "ven%" -- for venue ids
AND v2.ven_type LIKE "beach"
AND v.vendor_id = "ven_49"

UNION -- adding flowers
-- Flowers: 
SELECT DISTINCT(vendor_name), vendor_depart, vendor_location,
CASE                                                            -- assigning a size to it
	WHEN 	(v.vendor_name LIKE 'mandy scott events' OR
			 v.vendor_name LIKE 'absolute elegance floral' OR	
             v.vendor_name LIKE 'dragonfly floristic')
            THEN "sml"
END AS 	wedding_size,
CASE                                                            -- assigning a budget
	WHEN 	(v.vendor_name LIKE 'mandy scott events' OR
             v.vendor_name LIKE 'dragonfly floristic')
			THEN "m"
	WHEN 	v.vendor_name LIKE 'absolute elegance floral'
			THEN "a"
END AS  budget_level

FROM products AS p
INNER JOIN Flower_Season_Style AS f ON p.product_id = f.product_id
JOIN vendors AS v
ON p.vendor_id = v.vendor_id -- Joining flower_season_style and vendors 
WHERE p.vendor_id LIKE "flo%"
  AND (product_name LIKE "bouquet" OR product_name LIKE "flowers arrangement%")
  AND (flower_season LIKE "%summer%" OR flower_season LIKE "%spring%")
  AND (vendor_location LIKE "san%francisco%" OR vendor_location LIKE "daly%city" OR vendor_location LIKE "cupertino%")
  
UNION -- adding a new layer
-- Music:
SELECT DISTINCT(vendor_name), vendor_depart, vendor_location,
CASE                                                            -- assigning a size
	WHEN 	(v.vendor_name LIKE 'all ears' OR
			 v.vendor_name LIKE 'dj buddy holly' OR
             v.vendor_name LIKE 'sf deejays' OR
			 v.vendor_name LIKE 'total dj' OR
             v.vendor_name LIKE 'dj by the bay' OR
			 v.vendor_name LIKE 'oui boogie' OR
             v.vendor_name LIKE 'sounds spin n dj' OR
			 v.vendor_name LIKE 'local productions mobile dj' OR
             v.vendor_name LIKE 'tde wedding events')
            THEN "sml"
END AS 	wedding_size,
CASE                                                            -- assigning a budget 
	WHEN 	(v.vendor_name LIKE 'dj buddy holly' OR
             v.vendor_name LIKE 'dj by the bay' OR
             v.vendor_name LIKE 'sounds spin n dj')
			THEN "i"
    WHEN 	v.vendor_name LIKE 'total dj'
			THEN "a"
    WHEN 	(v.vendor_name LIKE 'all ears' OR
             v.vendor_name LIKE 'oui boogie')
			THEN "m"
	WHEN 	(v.vendor_name LIKE 'sf deejays' OR
			 v.vendor_name LIKE 'local productions mobile dj' OR
             v.vendor_name LIKE 'tde wedding events')
			THEN "l"
END AS  budget_level

FROM vendors AS v
JOIN Products AS p
ON v.vendor_id = p.vendor_id -- Joining products and vendors 
WHERE v.vendor_id LIKE "dj%"
AND (vendor_location LIKE "%san%mateo%" OR vendor_location LIKE "Milbrae%" OR vendor_location LIKE "san%francisco%")

UNION -- adding a new layer
-- Jewelry:
SELECT DISTINCT(vendor_name), vendor_depart, vendor_location,
CASE                                                            -- assigning a size
	WHEN 	(v.vendor_name LIKE 'brilliant earth' OR
			 v.vendor_name LIKE 'sausolito jewelers')
            THEN "sml"
END AS 	wedding_size,
CASE                                                            -- assigning a budget 
	WHEN 	v.vendor_name LIKE 'brilliant earth'  
			THEN "ia"
    WHEN 	v.vendor_name LIKE 'sausolito jewelers'  
			THEN "ml"
END AS  budget_level

FROM vendors AS v
JOIN products AS p
ON v.vendor_id = p.vendor_id -- Joining products and vendors 
JOIN material AS m
ON p.product_id = m.product_id -- also joining material
JOIN categories AS c
ON p.product_id = c.product_id -- and adding categories for filter
WHERE v.vendor_id LIKE "jwl%"
AND (v.vendor_location LIKE "Palo%Alto%" OR v.vendor_location LIKE "san%francisco%" OR v.vendor_location LIKE "sausolito%")
AND material_name = "gold"
AND (category_name = "necklace" OR category_name = "ring")

UNION -- adding a new layer
-- Photo and Video:

SELECT DISTINCT(vendor_name), vendor_depart, vendor_location,
CASE                                                            -- assigning a size
    WHEN (v.vendor_name LIKE 'apollo fotografie' OR
          v.vendor_name LIKE '1pshot' OR
          v.vendor_name LIKE 'silver seas' OR
          v.vendor_name LIKE 'skippy tv weddings' OR
          v.vendor_name LIKE 'danny rey films' OR
          v.vendor_name LIKE 'final frame studios' OR
          v.vendor_name LIKE 'brighter lights' OR
          v.vendor_name LIKE 'timeless tree weddings' OR
          v.vendor_name LIKE 'sasha photography' OR
          v.vendor_name LIKE 'lumitone photography and cinematography' OR
          v.vendor_name LIKE 'hand in hand production' OR
          v.vendor_name LIKE 'matthew james ross photo and video' OR
          v.vendor_name LIKE 'maineline studios' OR
          v.vendor_name LIKE 'privilege films' OR
          v.vendor_name LIKE 'modest reaction films' OR
          v.vendor_name LIKE 'george street photo and video' OR
          v.vendor_name LIKE 'trung hoang photography' OR
          v.vendor_name LIKE 'annamae photo' OR
          v.vendor_name LIKE 'jenn justice photography' OR
          v.vendor_name LIKE 'kelli santos photography' OR
          v.vendor_name LIKE 'all on deck photos' OR
          v.vendor_name LIKE 'splashes of time photography' OR
          v.vendor_name LIKE 'hannah leigh llc' OR
          v.vendor_name LIKE 'alex pimentel photography' OR
          v.vendor_name LIKE 'alina roz photography' OR
          v.vendor_name LIKE 'daelin waschke photography' OR
          v.vendor_name LIKE 'forefront photography' OR
          v.vendor_name LIKE 'julia goldberg photography' OR
          v.vendor_name LIKE 'bailey w photography')
		 THEN 'sml'
	END AS wedding_size,
CASE                                                            -- assigning a budget 
	WHEN (v.vendor_name LIKE 'george street photo and video' OR
	      v.vendor_name LIKE 'jenn justice photography' OR
		  v.vendor_name LIKE 'daelin waschke photography' OR
		  v.vendor_name LIKE 'julia goldberg photography' OR
		  v.vendor_name LIKE 'bailey w photography')
		 THEN "i"
	WHEN (v.vendor_name LIKE 'danny rey films' OR
	      v.vendor_name LIKE 'final frame studios' OR
		  v.vendor_name LIKE 'lumitone photography and cinematography' OR
          v.vendor_name LIKE 'matthew james ross photo and video' OR
          v.vendor_name LIKE 'maineline studios' OR
          v.vendor_name LIKE 'privilege films' OR
          v.vendor_name LIKE 'modest reaction films' OR
          v.vendor_name LIKE 'splashes of time photography' OR
          v.vendor_name LIKE 'alina roz photography' OR
          v.vendor_name LIKE 'forefront photography' OR 
          v.vendor_name LIKE  'hand in hand production')
		 THEN "a"
	WHEN (v.vendor_name LIKE 'trung hoang photography' OR
	      v.vendor_name LIKE 'annamae photo' OR
		  v.vendor_name LIKE 'kelli santos photography' OR
		  v.vendor_name LIKE 'all on deck photos' OR
		  v.vendor_name LIKE 'apollo fotografie' OR
          v.vendor_name LIKE '1pshot' OR
          v.vendor_name LIKE 'skippy tv weddings' OR
          v.vendor_name LIKE 'timeless tree weddings' OR
          v.vendor_name LIKE 'sasha photography' OR
          v.vendor_name LIKE 'alex pimentel photography')
		 THEN "m"
	WHEN (v.vendor_name LIKE 'silver seas' OR
	      v.vendor_name LIKE 'brighter lights' OR
		  v.vendor_name LIKE 'hannah leigh llc')
		 THEN "l"
END AS budget_level

FROM vendors AS v
JOIN products AS p
ON v.vendor_id = p.vendor_id -- Joining products and vendors 
WHERE v.vendor_id LIKE "vid%"
AND (vendor_location LIKE "Belmont%" OR vendor_location LIKE "san%francisco%" OR vendor_location LIKE "sausalito%")

UNION -- adding a new layer
-- Hair and Makeup:

SELECT DISTINCT(vendor_name), vendor_depart, vendor_location,
CASE                                                            -- assigning a size
	WHEN 	(v.vendor_name LIKE 'stylebee' OR
			 v.vendor_name LIKE 'shannon le' OR
			 v.vendor_name LIKE 'beyond beauty inc.' OR
             v.vendor_name LIKE 'the hair studio' OR
			 v.vendor_name LIKE 'leece stylz by alicia lau')
    THEN "sml"
    
	WHEN 	(v.vendor_name LIKE 'maia beauty' OR
			 v.vendor_name LIKE 'wow pretty makeup and hair agency' OR
			 v.vendor_name LIKE 'stellakim artistry' OR
			 v.vendor_name LIKE 'sephora')
    THEN "s"

	WHEN 	(v.vendor_name LIKE 'primadonnamakeover hair  makeup  lipstick mix bar' OR
			 v.vendor_name LIKE 'beauty by pace')
    THEN "sm"

END AS 	wedding_size,

CASE                                                            -- assigning a budget 
	WHEN 	v.vendor_name LIKE 'stylebee'
			THEN "l"
	WHEN 	v.vendor_name LIKE 'maia beauty'
			THEN "iaml"
	WHEN 	v.vendor_name LIKE 'shannon le'
			THEN "ial"
	WHEN 	v.vendor_name LIKE 'beyond beauty inc.'
			THEN "im"
	WHEN 	v.vendor_name LIKE 'wow pretty makeup and hair agency'
			THEN "m"
	WHEN 	v.vendor_name LIKE 'primadonnamakeover hair  makeup  lipstick mix bar'
			THEN "iam"
	WHEN 	(v.vendor_name LIKE 'beauty by pace' OR
             v.vendor_name LIKE 'stellakim artistry' OR
			 v.vendor_name LIKE 'leece stylz by alicia lau')
			THEN "iml"
    WHEN 	(v.vendor_name LIKE 'the hair studio' OR
             v.vendor_name LIKE 'sephora')
			THEN "i"
END AS budget
FROM vendors AS v
JOIN products AS p
ON v.vendor_id = p.vendor_id -- Joining products and vendors 
WHERE v.vendor_id LIKE "hmu%"
AND (vendor_location LIKE "Hillsborough%" OR vendor_location LIKE "burlingame%" OR vendor_location LIKE "san%francisco%")
AND (unit_vol LIKE "%bride%" OR unit_vol LIKE "%groom%" )
AND product_name NOT LIKE 'traditional'


UNION -- adding a new layer

-- Dress and Attire:

SELECT DISTINCT(vendor_name), vendor_depart, vendor_location,
CASE                                                            -- assigning a size
    WHEN (v.vendor_name LIKE 'casablanca bridal' OR
          v.vendor_name LIKE 'allure bridal' OR
          v.vendor_name LIKE 'misaac' OR
          v.vendor_name LIKE 'birdy grey' OR
          v.vendor_name LIKE 'aw bridal' OR
          v.vendor_name LIKE 'blacktux')
    THEN "sml"
END AS wedding_size,
CASE                                                            -- assigning a budget 
	WHEN 	v.vendor_name LIKE '%casablanca bridal%'
            THEN "l"
	WHEN   (v.vendor_name LIKE 'allure bridal' OR
			 v.vendor_name LIKE 'misaac' OR
             v.vendor_name LIKE 'birdy grey')
             THEN "a"
    WHEN   v.vendor_name LIKE 'aw bridal'
             THEN "i"
	WHEN   v.vendor_name LIKE 'blacktux'
			 THEN  "m" 
END AS  budget_level


FROM vendors AS v
JOIN Products AS p
ON v.vendor_id = p.vendor_id -- Joining products and vendors 
WHERE v.vendor_id LIKE "att%"
AND (p.product_name LIKE "%bridesmaids%" OR p.product_name LIKE "%lace%off%shoulder%" OR p.product_name LIKE "%trumpet%scoop%" OR p.product_name LIKE "%charcoal%" OR p.product_name LIKE "%bridal%")

UNION -- adding a new layer

-- Catering
SELECT DISTINCT(vendor_name), vendor_depart, vendor_location,
CASE                                                            -- assigning a size
	WHEN 	(v.vendor_name LIKE 'fogcutter' OR
			 v.vendor_name LIKE 'fraiche catering' OR
             v.vendor_name LIKE 'stock and bones' OR
			 v.vendor_name LIKE 'culinary eye catering and events')
            THEN "sml"
END AS 	wedding_size,
CASE                                                            -- assigning a budget 
	WHEN 	(v.vendor_name LIKE 'fogcutter' OR
			 v.vendor_name LIKE 'fraiche catering' OR
             v.vendor_name LIKE 'culinary eye catering and events')
             THEN "m"
	WHEN 	v.vendor_name LIKE 'stock and bones'  
			THEN "l"
END AS  budget_level

FROM vendors AS v
JOIN products AS p
ON v.vendor_id = p.vendor_id -- Joining products and vendors 
JOIN cuisine AS c
ON p.product_id = c.product_id 
WHERE v.vendor_id LIKE "cat%"
AND (vendor_location LIKE "mountain%view%" OR vendor_location LIKE "half%moon%bay" OR vendor_location LIKE "san%francisco%")
AND (product_name LIKE "%buffet%" OR product_name LIKE "%station%" OR product_name LIKE "%hors%")
AND italian = 1 
AND french = 1


UNION -- adding a new layer

-- Rentals:
SELECT DISTINCT(vendor_name), vendor_depart, vendor_location,
CASE                                                            -- assigning a size
	WHEN 	(v.vendor_name LIKE 'abbey party rents sf' OR
			 v.vendor_name LIKE 'all seasons event rental' OR
             v.vendor_name LIKE 'bright events rentals' OR
             v.vendor_name LIKE 'hensley event resources' OR
			 v.vendor_name LIKE 'janettes events' OR
             v.vendor_name LIKE 'posh balloon studio ' OR
			 v.vendor_name LIKE 'sweet wonders candy buffet and event design')
            THEN "sml"
END AS 	wedding_size,
CASE                                                            -- assigning a budget 
	WHEN 	v.vendor_name LIKE 'abbey party rents sf'  
			THEN "i"
    WHEN 	(v.vendor_name LIKE 'all seasons event rental' OR
			 v.vendor_name LIKE 'sweet wonders candy buffet and event design')
			THEN "m"
	WHEN 	(v.vendor_name LIKE 'bright events rentals' OR
			 v.vendor_name LIKE 'janettes events')
			THEN "a"
	WHEN 	v.vendor_name LIKE 'hensley event resources'  
			THEN "ia"
    WHEN 	v.vendor_name LIKE 'posh balloon studio '  
			THEN "l"        
END AS  budget_level

FROM vendors AS v
JOIN products AS p
ON v.vendor_id = p.vendor_id -- Joining products and vendors 
WHERE v.vendor_id LIKE "ren%"
AND (vendor_location LIKE "redwood%" OR vendor_location LIKE "brisbane%" OR vendor_location LIKE "daly%city%" OR vendor_location LIKE "san%francisco%" OR vendor_location LIKE "palo%alto%")

UNION -- adding a new layer

-- Invitations:
SELECT DISTINCT(vendor_name), vendor_depart, vendor_location,
CASE                                                            -- assigning a size
	WHEN 	(v.vendor_name LIKE 'coffee n cream press' OR
			 v.vendor_name LIKE 'theknot' OR
             v.vendor_name LIKE 'etsy' OR
			 v.vendor_name LIKE 'paperculture')
            THEN "sml"
END AS 	wedding_size,
CASE                                                            -- assigning a budget 
	WHEN 	v.vendor_name LIKE 'coffee n cream press'  
			THEN "l"
    WHEN 	v.vendor_name LIKE 'theknot'  
			THEN "iam"
	WHEN 	v.vendor_name LIKE 'etsy'  
			THEN "m"
	WHEN 	v.vendor_name LIKE 'paperculture'  
			THEN "am"
END AS  budget_level

FROM vendors AS v
JOIN products AS p
ON v.vendor_id = p.vendor_id -- Joining products and vendors 
JOIN inv_characteristics AS i
ON v.vendor_id = i.vendor_id
WHERE v.vendor_id LIKE "inv%"
AND (product_category LIKE "RSVP%" OR product_category LIKE "TableNumber%" OR product_category LIKE "invitation%"));


-- Choosing all details from the relevant_vendors table:
SELECT *
FROM relevant_vendors;










-- Dropping the combination_unified_table if it exists
DROP TABLE IF EXISTS vendor_options;

-- Creating a temporary table for combination_unified_table
CREATE TEMPORARY TABLE vendor_options (
    wedding_size VARCHAR(50),
    budget_level VARCHAR(50),
    flowers VARCHAR(50),
    venues VARCHAR(50),
    music VARCHAR(50),
    jewelry VARCHAR(50),
    photo_video VARCHAR(50),
    hair_makeup VARCHAR(50),
    dress_attire VARCHAR(50),
    catering VARCHAR(50),
    rentals VARCHAR(50),
    invitations VARCHAR(50),
    theme VARCHAR(50),
    estimated_budget VARCHAR(50)
);

-- Inserting data for small and inexpensive wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('small',
		'inexpensive',
        'absolute elegance floral',
        'half moon bay golf links',
        'dj buddy holly',
        'brilliant earth',
        'julia goldberg photography',
        'the hair studio',
        'aw bridal',
        'fogcutter',
        'abbey party rents sf',
        'theknot',
        'romantic',
        18426);

-- Inserting data for small and affordable wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('small',
		'affordable',
        'absolute elegance floral',
        'half moon bay golf links',
        'total dj',
        'brilliant earth',
        'lumitone photography and cinematography',
        'maia beauty',
        'allure bridal',
        'culinary eye catering and events',
        'hensley event resources',
        'paperculture',
		'romantic',
        27610);

-- Inserting data for small and moderate wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('small',
		'moderate',
        'dragonfly floristic',
        'half moon bay golf links',
        'all ears',
        'sausolito jewelers',
        'annamae photo',
        'stellakim artistry',
        'blacktux',
        'stock and bones',
        'all seasons event rental',
        'paperculture',
		'romantic',
        37853);

-- Inserting data for small and luxury wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('small',
		'luxury',
        'dragonfly floristic',
        'half moon bay golf links',
        'sf deejays',
        'sausolito jewelers',
        'silver seas',
        'shannon le',
        'casablanca bridal',
        'fraiche catering',
        'all seasons event rental',
        'coffee n cream press',
		'romantic',
        48726);

-- Inserting data for medium and inexpensive wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('medium',
		'inexpensive',
        'absolute elegance floral',
        'half moon bay golf links',
        'dj buddy holly',
        'brilliant earth',
        'daelin waschke photography',
        'beyond beauty inc.',
        'aw bridal',
        'fogcutter',
        'abbey party rents sf',
        'theknot',
		'romantic',
        29108);

-- Inserting data for medium and affordable wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('medium',
		'affordable',
        'absolute elegance floral',
        'half moon bay golf links',
        'total dj',
        'brilliant earth',
        'splashes of time photography',
        'maia beauty',
        'misaac',
        'culinary eye catering and events',
        'hensley event resources',
        'paperculture',
        'romantic',
        43525);

-- Inserting data for medium and moderate wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('medium',
		'moderate',
        'dragonfly floristic',
        'half moon bay golf links',
        'all ears',
        'sausolito jewelers',
        'all on deck photos',
        'beauty by pace',
        'blacktux',
        'stock and bones',
        'all seasons event rental',
        'paperculture',
        'romantic',
        59032);

-- Inserting data for medium and luxury wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('medium',
		'luxury',
        'dragonfly floristic',
        'half moon bay golf links',
        'sf deejays',
        'sausolito jewelers',
        'hannah leigh llc',
        'shannon le',
        'casablanca bridal',
        'fraiche catering',
        'all seasons event rental',
        'coffee n cream press',
        'romantic',
        76760);

-- Inserting data for large and inexpensive wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('large',
		'inexpensive',
        'absolute elegance floral',
        'half moon bay golf links',
        'dj buddy holly',
        'brilliant earth',
        'jenn justice photography',
        'beyond beauty inc.',
        'aw bridal',
        'fogcutter',
        'abbey party rents sf',
        'theknot',
        'romantic',
        41818);
        
-- Inserting data for large and affordable wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('large',
		'affordable',
        'absolute elegance floral',
        'half moon bay golf links',
        'total dj',
        'brilliant earth',
        'modest reaction films',
        'maia beauty',
        'birdy grey',
        'culinary eye catering and events',
        'hensley event resources',
        'paperculture',
		'romantic',
        60984);

-- Inserting data for large and moderate wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('large',
		'moderate',
        'dragonfly floristic',
        'half moon bay golf links',
        'all ears',
        'sausolito jewelers',
        'apollo fotografie',
        'beyond beauty inc.',
        'blacktux',
        'stock and bones',
        'all seasons event rental',
        'paperculture',
        'romantic',
        82395);

-- Inserting data for large and luxury wedding
INSERT INTO vendor_options (wedding_size, budget_level, flowers, venues, music, jewelry, photo_video, hair_makeup, dress_attire, catering, rentals, invitations, theme, estimated_budget)
VALUES ('large',
		'luxury',
        'dragonfly floristic',
        'half moon bay golf links',
        'sf deejays',
        'sausolito jewelers',
        'brighter lights',
        'leece stylz by alicia lau',
        'casablanca bridal',
        'fraiche catering',
        'all seasons event rental',
        'coffee n cream press',
        'romantic',
        107260);

-- Final query to select all data from the table
SELECT *
FROM vendor_options;