-- Get all star events
WITH star_events AS (
  SELECT
    repo.name as repo,
    actor.id as actor_id,
    created_at
  FROM `githubarchive.month.*`
  WHERE
    type = "WatchEvent"
    AND repo.name != "/"
),

-- Filter to the top 10k repos by total stars
top_repos AS (
  SELECT
    repo,
    COUNT(DISTINCT actor_id) as stargazers
  FROM star_events
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 10000
),

-- Aggregate monthly stars (by unique users)
monthly_counts AS (
  SELECT
    repo,
    format_date("%Y-%m-01", created_at) as month,
    COUNT(DISTINCT actor_id) as monthly_count
  FROM star_events
  WHERE
    repo IN (SELECT repo FROM top_repos)
  GROUP BY 1, 2
)

-- Convert monthly star counts to cumulative totals
SELECT
  repo,
  month,
  SUM(monthly_count) OVER (PARTITION BY repo ORDER BY month ROWS UNBOUNDED PRECEDING) as approx_stars
FROM monthly_counts
ORDER BY 2 DESC, 3 DESC