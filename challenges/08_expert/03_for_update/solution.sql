BEGIN;

WITH next_job AS (
    SELECT job_id
    FROM jobs
    WHERE status = 'pending'
    ORDER BY created_at
    FOR UPDATE SKIP LOCKED
    LIMIT 1
)
UPDATE jobs
SET status = 'in_progress'
WHERE job_id = (SELECT job_id FROM next_job);

COMMIT;
