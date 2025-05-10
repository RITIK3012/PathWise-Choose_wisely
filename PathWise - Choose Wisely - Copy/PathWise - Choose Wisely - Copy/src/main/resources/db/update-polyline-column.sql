-- Update the actual_polyline column type from TEXT to LONGTEXT to handle larger polyline data
ALTER TABLE rides MODIFY COLUMN actual_polyline LONGTEXT; 