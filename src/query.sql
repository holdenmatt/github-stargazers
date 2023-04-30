WITH star_events AS (
  SELECT
    repo.name as repo,
    actor.id as actor_id,
    created_at
  FROM `githubarchive.month.2015*`
  WHERE type="WatchEvent"
),

top_repos AS (
  SELECT
    repo,
    COUNT(DISTINCT actor_id) as stargazers
  FROM star_events
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 10000
)

SELECT
  repo,
  format_date("%Y-%m-01", created_at) as month,
  COUNT(DISTINCT actor_id) as monthly_stargazers
FROM star_events
WHERE
  repo IN (SELECT repo FROM top_repos)
GROUP BY 1, 2
ORDER BY 2 ASC, 3 DESC