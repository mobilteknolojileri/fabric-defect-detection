import unittest

from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


class TestApp(unittest.TestCase):
    def test_root_serves_status_page(self):
        response = client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertIn("text/html", response.headers["content-type"])

    def test_detect_rejects_request_without_file(self):
        response = client.post("/detect")
        self.assertEqual(response.status_code, 422)


if __name__ == "__main__":
    unittest.main()
