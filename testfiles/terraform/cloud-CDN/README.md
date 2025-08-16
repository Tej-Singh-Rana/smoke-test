📄 upload.sh (Optional – for testing content)

#!/bin/bash

PROJECT_ID=your-project-id
gsutil mb -p $PROJECT_ID -l us-central1 gs://$PROJECT_ID-cdn-bucket/
echo "<h1>Served via CDN</h1>" > index.html
gsutil cp index.html gs://$PROJECT_ID-cdn-bucket/
gsutil web set -m index.html gs://$PROJECT_ID-cdn-bucket/
