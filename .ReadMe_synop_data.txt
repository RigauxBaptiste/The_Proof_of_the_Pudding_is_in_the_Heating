ReadMe file for the "synop_data.csv" datafile.

### Description (from https://opendata.meteo.be/geonetwork/srv/api/records/RMI_DATASET_SYNOP/formatters/xml): 

"The SYNOP data of RMI contain the observations of the synoptic network, currently consisting of 29 stations, 13 of which are owned by RMI. The other stations belong to MeteoWing (8 stations), Skeyes (7 stations). There is also 1 foreign station. All SYNOP data is given in Universal Time! (local time winter = UT +1; local time summer = UT + 2) Parameters: 1. Precipitation: PRECIP_QUANTITY + PRECIP_RANGE 2. Temperature: TEMP + TEMP_MIN + TEMP_MAX + TEMP_GRASS_MIN 3. Wind: WIND_SPEED + WIND_SPEED_UNIT + WIND_DIRECTION + WIND_PEAK_SPEED 4. relative humidity: HUMIDITY_RELATIVE 5. weather type: WEATHER_CURRENT 6. air pressure: PRESSURE of PRESSURE_STATION_LEVEL 7. sunshine duration: SUN_DURATION_24H 8. Global radiation: SHORT_WAVE_FROM_SKY_24HOUR 9. Total cloudiness: CLOUDINESS"

### Source of the data

https://opendata.meteo.be/geonetwork/srv/eng/catalog.search#/metadata/RMI_DATASET_SYNOP extracted on the 29/07/23. 

The dataset is filtered to only include data from Melle (close to Ghent): 
FID,code,the_geom,altitude,name,date_begin,date_end
synop_station.6434.2003-04-02 06:00:00+00,6434,POINT (50.980293 3.816003),15,MELLE,2003-04-02T06:00:00,

### Details of the data manager: 

Royal Meteorological Institute of Belgium
    Point of contact:
    info@meteo.be 

### Data quality:

Regarding data quality, the Royal Meteorological Institute of Belgium mentions (https://opendata.meteo.be/geonetwork/srv/api/records/RMI_DATASET_SYNOP/formatters/xml): 
"SYNOP data are first subjected to an automatic quality control where we check for missing values and if the values are within certain physical limits. This automatic QC is followed by a manual QC performed by RMI staff members. Different instruments are calibrated by RMI in its calibration laboratory. The TEMPERATURE sensors are calibrated by comparing the pt100 sensor of the station with the pt25 reference sensor of the calibration lab (which are calibrated by the national metrology lab). They are compared in a thermostatic bath which contains an “azeotropic mixture of propyleenglycol and water” (50-50%). This allows the same bath and mixture to be used for the entire temperature range (-25°C to 35°C). The calibration is performed at 6 fixed temperatures: -25°C, -10°C, 0°C, 10°C, 20°C and 35°C. The calibration of the PRESSURE sensors is performed using a balance system with two pumps (for under and over pressure) and three reference sensors: a recent one (rpm4) and two older ones (paroscientific) in an automated way with 3 up and down cycles within the pressure range 810-1050hPa, with a calibration every 30hPa. The calibration of the HUMIDITY sensors is performed in a climate closet (Weiss) by varying the temperature and relative humidity and by using a chilled mirror sensor."

### Content and units: 

Cf. https://opendata.meteo.be/documentation/?dataset=synop&lang=en:
"""
Precipitation

PRECIP_QUANTITY = amount of precipitation in mm.

PRECIP_RANGE = period over which PRECIP_QUANTITY was measured.

    1 = past 6h
    2 = past 12h
    4 = past 24h

Value at 0600UT: sum of precipitation between 1750-0550UT

Value at 1200UT: sum of precipitation between 0550-1150UT

Value at 1800UT: sum of precipitation between 0550-1750UT

Value at 0000UT: sum of precipitation between 1750-2350UT
Temperature

TEMP = air temperature at 1.5m in °C (hourly)
1 value every hour: average measured between (T – 11 min) and (T – 10 min)

TEMP_MIN = minimum temperature between 18h UT (previous day) and 6h UT (current day) in °C (1 value per day)
min between 1750UT (previous day) and 0550UT (current day).

TEMP_MAX = maximum temperature between 6h UT and 18h UT in °C (1 value per day)
max between 0550 and 1750UT

TEMP_GRASS_MIN = minimum temperature at the soil (°C) at 6UT and 9UT
Temperature measured between 1750 to 0550 for 0600 UT and between 2150 to 0850 for 0900UT
Wind

WIND_SPEED = average wind speed of the last 10 minutes at 10m altitude (hourly)
measured between (T – 20 min) and (T – 10 min)

WIND_SPEED_UNIT = unit of the wind speed
0,1 = m/s or 3,4 = knots

WIND_DIRECTION = wind direction in degrees (hourly)
average wind direction between (T – 20 min) and (T – 10 min)

WIND_PEAK_SPEED = maximum wind speed (m/s)

    Value at 0300UT: maximum between 2350-0250UT
    Value at 0600UT: maximum between 2350-0550UT
    Value at 0900UT: maximum between 0550-0850UT
    Value at 1200UT: maximum between 0550-1150UT
    Value at 1500UT: maximum between 1150-1450UT
    Value at 1800UT: maximum between 1150-1750UT
    Value at 2100UT: maximum between 1750-2050UT
    Value at 0000UT: maximum between 1750-2350UT

Relative humidity

HUMIDITY_RELATIVE = relative humidity of the air in % (hourly)
average RH measured/calculated between (T – 11 min) and (T – 10 min)
Weather type

WEATHER_CURRENT = description of the current weather type (hourly)
instantaneous
Code	Current weather
0	clear skies
1	clouds dissolving
2	state of sky unchanged
3	clouds developing
4	visibility reduced by smoke
5	haze
6	widespread dust in suspension not raised by wind
7	dust or sand raised by wind
8	well developed dust or sand whirls
9	dust or sand storm within sight but not at station
10	mist
11	patches of shallow fog
12	continuous shallow fog
13	lightning visible, no thunder heard
14	precipitation within sight but not hitting ground
15	distant precipitation but not falling at station
16	nearby precipitation but not falling at station
17	thunderstorm but no precipitation falling at station
18	squalls within sight but no precipitation falling at station
19	funnel clouds within sight
20	drizzle (not freezing) or snow grains
21	rain
22	snow
23	rain and snow
24	freezing rain
25	rain showers
26	snow showers
27	hail showers
28	fog
29	thunderstorms
30	slight to moderate duststorm, decreasing in intensity
31	slight to moderate duststorm, no change
32	slight to moderate duststorm, increasing in intensity
33	severe duststorm, decreasing in intensity
34	severe duststorm, no change
35	severe duststorm, increasing in intensity
36	slight to moderate drifting snow, below eye level
37	heavy drifting snow, below eye level
38	slight to moderate drifting snow, above eye level
39	heavy drifting snow, above eye level
40	Fog at a distance
41	patches of fog
42	fog, sky visible, thinning
43	fog, sky not visible, thinning
44	fog, sky visible, no change
45	fog, sky not visible, no change
46	fog, sky visible, becoming thicker
47	fog, sky not visible, becoming thicker
48	fog, depositing rime, sky visible
49	fog, depositing rime, sky not visible
50	intermittent light drizzle
51	continuous light drizzle
52	intermittent moderate drizzle
53	continuous moderate drizzle
54	intermittent heavy drizzle
55	continuous heavy drizzle
56	light freezing drizzle
57	moderate to heavy freezing drizzle
58	light drizzle and rain
59	moderate to heavy drizzle and rain
60	intermittent light rain
61	continuous light rain
62	intermittent moderate rain
63	continuous moderate rain
64	intermittent heavy rain
65	continuous heavy rain
66	light freezing rain
67	moderate to heavy freezing rain
68	light rain and snow
69	moderate to heavy rain and snow
70	intermittent light snow
71	continuous light snow
72	intermittent moderate snow
73	continuous moderate snow
74	intermittent heavy snow
75	continuous heavy snow
76	diamond dust
77	snow grains
78	snow crystals
79	ice pellets
80	light rain showers
81	moderate to heavy rain showers
82	violent rain showers
83	light rain and snow showers
84	moderate to heavy rain and snow showers
85	light snow showers
86	moderate to heavy snow showers
87	light snow/ice pellet showers
88	moderate to heavy snow/ice pellet showers
89	light hail showers
90	moderate to heavy hail showers
91	thunderstorm in past hour, currently only light rain
92	thunderstorm in past hour, currently only moderate to heavy rain
93	thunderstorm in past hour, currently only light snow or rain/snow mix
94	thunderstorm in past hour, currently only moderate to heavy snow or rain/snow mix
95	light to moderate thunderstorm
96	light to moderate thunderstorm with hail
97	heavy thunderstorm
98	heavy thunderstorm with duststorm
99	heavy thunderstorm with hail
100	No significant weather observed
101	Clouds generally dissolving or becoming less developed during the past hour
102	State of sky on the whole unchanged during the past hour
103	Clouds generally forming or developing during the past hour
104	Haze or smoke, or dust in suspension in the air, visibility equal to, or greater than, 1 km
105	Haze or smoke, or dust in suspension in the air, visibility less than 1 km
110	Mist
111	Diamond dust
112	Distant lightning
118	Squalls
120	Fog
121	Precipitation
122	Drizzle (not freezing) or snow grains
123	Rain (not freezing)
124	Snow
125	Freezing drizzle or freezing rain
126	Thunderstorm (with or without precipitation)
127	Blowing or drifting snow or sand
128	Blowing or drifting snow or sand, visibility equal to, or greater than, 1 km
129	Blowing or drifting snow or sand, visibility less than 1 km
130	Fog
131	Fog or ice fog in patches
132	Fog or ice fog, has become thinner during the past hour
133	Fog or ice fog, no appreciable change during the past hour
134	Fog or ice fog, has begun or become thicker during the past hour
135	Fog, depositing rime
140	Precipitation
141	Precipitation, slight or moderate
142	Precipitation, heavy
143	Liquid precipitation, slight or moderate
144	Liquid precipitation, heavy
145	Solid precipitation, slight or moderate
146	Solid precipitation, heavy
147	Freezing precipitation, slight or moderate
148	Freezing precipitation, heavy
150	Drizzle
151	Drizzle, not freezing, slight
152	Drizzle, not freezing, moderate
153	Drizzle, not freezing, heavy
154	Drizzle, freezing, slight
155	Drizzle, freezing, moderate
156	Drizzle, freezing, heavy
157	Drizzle and rain, slight
158	Drizzle and rain, moderate or heavy
160	Rain
161	Rain, not freezing, slight
162	Rain, not freezing, moderate
163	Rain, not freezing, heavy
164	Rain, freezing, slight
165	Rain, freezing, moderate
166	Rain, freezing, heavy
167	Rain (or drizzle) and snow, slight
168	Rain (or drizzle) and snow, moderate or heavy
170	snow
171	Snow, slight
172	Snow, moderate
173	Snow, heavy
174	Ice pellets, slight
175	Ice pellets, moderate
176	Ice pellets, heavy
177	Snow grains
178	Ice crystals
180	Shower(s) or intermittent precipitation
181	Rain shower(s) or intermittent rain, slight
182	Rain shower(s) or intermittent rain, moderate
183	Rain shower(s) or intermittent rain, heavy
184	Rain shower(s) or intermittent rain, violent
185	Snow shower(s) or intermittent snow, slight
186	Snow shower(s) or intermittent snow, moderate
187	Snow shower(s) or intermittent snow, heavy
189	Hail
190	Thunderstorm
191	Thunderstorm, slight or moderate, with no precipitation
192	Thunderstorm, slight or moderate, with rain showers and/or snow showers
193	Thunderstorm, slight or moderate, with hail
194	Thunderstorm, heavy, with no precipitation
195	Thunderstorm, heavy, with rain showers and/or snow showers
196	Thunderstorm, heavy, with hail
199	Tornado
204	Volcanic ash suspended in the air aloft
206	Thick dust haze, visibility less than 1 km
207	Blowing spray at the station
208	Drifting dust (sand)
209	Wall of dust or sand in distance (like haboob)
210	Snow haze
211	Whiteout
213	Lightning, cloud to surface
217	Dry thunderstorm
219	Tornado cloud (destructive) at or within sight of the station during preceding hour or at the time of observation
220	Deposition of volcanic ash
221	Deposition of dust or sand
222	Deposition of dew
223	Deposition of wet snow
224	Deposition of soft rime
225	Deposition of hard rime
226	Deposition of hoar frost
227	Deposition of glaze
228	Deposition of ice crust (ice slick)
230	Duststorm or sandstorm with temperature below 0° C
239	Blowing snow, impossible to determine whether snow is falling or not
241	Fog on sea
242	Fog in valleys
243	Arctic or Antarctic sea smoke
244	Steam fog (sea, lake or river)
245	Steam log (land)
246	Fog over ice or snow cover
247	Dense fog, visibility 60–90 m
248	Dense fog, visibility 30–60 m
249	Dense fog, visibility less than 30 m
250	Drizzle, rate of fall less than 0.10 mm h-1
251	Drizzle, rate of fall 0.10–0.19 mm h–1
252	Drizzle, rate of fall 0.20–0.39 mm h–1
253	Drizzle, rate of fall 0.40–0.79 mm h-1
254	Drizzle, rate of fall 0.80–1.59 mm h–1
255	Drizzle, rate of fall 1.60–3.19 mm h–1
256	Drizzle, rate of fall 3.20–6.39 mm h–1
257	Drizzle, rate of fall 6.4 mm h-1 or more
259	Drizzle and snow
260	Rain, rate of fall less than 1.0 mm h-1
261	Rain, rate of fall 1.0–1.9 mm h-1
262	Rain, rate of fall 2.0–3.9 mm h–1
263	Rain, rate of fall 4.0–7.9 mm h–1
264	Rain, rate of fall 8.0–15.9 mm h–1
265	Rain, rate of fall 16.0–31.9 mm h–1
266	Rain, rate of fall 32.0–63.9 mm h–1
267	Rain, rate of fall 64.0 mm h–1 or more
270	Snow, rate of fall less than 1.0 cm h-1
271	Snow, rate of fall 1.0–1.9 cm h–1
272	Snow, rate of fall 2.0–3.9 cm h–1
273	Snow, rate of fall 4.0–7.9 cm h–1
274	Snow, rate of fall 8.0–15.9 cm h–1
275	Snow, rate of fall 16.0–31.9 cm h–1
276	Snow, rate of fall 32.0–63.9 cm h–1
277	Snow, rate of fall 64.0 cm h–1 or more
278	Snow or ice crystal precipitation from a clear sky
279	Wet snow, freezing on contact
280	Precipitation of rain
281	Precipitation of rain, freezing
282	Precipitation of rain and snow mixed
283	Precipitation of snow
284	Precipitation of snow pellets or small hall
285	Precipitation of snow pellets or small hail, with rain
286	Precipitation of snow pellets or small hail, with rain and snow mixed
287	Precipitation of snow pellets or small hail, with snow
288	Precipitation of hail
289	Precipitation of hail, with rain
290	Precipitation of hall, with rain and snow mixed
291	Precipitation of hail, with snow
292	Shower(s) or thunderstorm over sea
293	Shower(s) or thunderstorm over mountains
508	No significant phenomenon to report, present and past weather omitted
509	No observation, data not available, present and past weather omitted
510	Present and past weather missing, but expected
511	Missing value
Pressure

PRESSURE = air pressure at sea level (hPa) (hourly)
measured between (T – 11 min) and (T – 10 min)

PRESSURE_STATION_LEVEL = air pressure at station level (hPa) (hourly)
measured between (T – 11 min) and (T – 10 min)
Sunshine duration

SUN_DURATION_24HOURS = sunshine duration (period during which more than 120W/m² in solar radiation is measured) over the last 24h (in minutes) (1 value per day)
measured between (T – 24 h 10 min) and (T – 10 min)
Global radiation

SHORT_WAVE_FROM_SKY_24HOURS: Global solar radiation integrated over 24h (in J/m²)
Global radiation measured between between (T – 24 h 10 min) and (T – 10 min)
Total cloudiness

CLOUDINESS = part of the sky covered in clouds (in octas)
instantaneous
"""
