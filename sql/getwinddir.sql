CREATE or replace FUNCTION getwinddir(dir int) RETURNS varchar
    AS $winddir$
declare
    windir varchar;
BEGIN
    IF dir = 0 THEN 
        RETURN 'N';
    ELSIF dir = 45 THEN
        RETURN 'NE';
    ELSIF dir = 90 THEN
        RETURN 'E';
    ELSIF dir = 135 THEN
        RETURN 'SE';
    ELSIF dir = 180 THEN
        RETURN 'S';
    ELSIF dir = 225 THEN
        RETURN 'SW';
    ELSIF dir = 270 THEN
        RETURN 'W';
    ELSIF dir = 315 THEN
        RETURN 'NW';
    ELSIF dir between 0 and 45 THEN
        RETURN 'NNE';
    ELSIF dir between 46 and 90 THEN
        RETURN 'ENE';
    ELSIF dir between 91 and 135 THEN
        RETURN 'ESE';
    ELSIF dir between 136 and 180 THEN
        RETURN 'SSE'; 
    ELSIF dir between 181 and 225 THEN
        RETURN 'SSW';
    ELSIF dir between 226 and 270 THEN
        RETURN 'WSW';
    ELSIF dir between 271 and 315 THEN
        RETURN 'WNW';
    ELSIF dir between 316 and 359 THEN
        RETURN 'NNW';
    END IF;
END;  
    $winddir$
    LANGUAGE plpgsql;