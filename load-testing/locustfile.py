from locust import HttpLocust, TaskSet, task

class WebsiteTasks(TaskSet):
    @task
    def index(self):
        self.client.get("/news.php")

class WebsiteUser(HttpLocust):
    task_set = WebsiteTasks
    min_wait = 5000
    max_wait = 15000


    histogram_quantile(0.9, rate(caddy_http_request_duration_seconds_bucket{namespace="default"}[5m])) > 0.05
      and
    rate(caddy_http_request_duration_seconds_count{namespace="default"}[5m]) > 1

    histogram_quantile(0.9, sum(rate(caddy_http_request_duration_seconds_bucket[5m])) by (job) ) / 1e+06

,pod="znn-