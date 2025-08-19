## GCLOUD CLI to push the files to bucket

📤 UPLOAD Commands
✅ Upload a single file to a bucket
```sh
gsutil cp file.txt gs://my-unique-bucket-patiala-456
```

✅ Upload a folder and its contents (recursively)
```sh
gsutil cp -r cloud-NAT gs://my-unique-bucket-patiala-456
```

✅ Upload with a custom object name
```sh
gsutil cp file.txt gs://your-bucket-name/renamed-file.txt
```

📥 DOWNLOAD Commands
✅ Download a file from bucket to local
```sh
gsutil cp gs://your-bucket-name/file.txt .
```

✅ Download a full folder from GCS
```sh
gsutil cp -r gs://your-bucket-name/folder-name/ ./local-folder/
```

📄 COPY (within buckets)
✅ Copy a file from one bucket to another
```sh
gsutil cp gs://source-bucket/file.txt gs://target-bucket/
```

✅ Copy an entire folder between buckets
```sh
gsutil cp -r gs://source-bucket/folder/ gs://target-bucket/
```

❌ DELETE Commands
✅ Delete a single file in the bucket
```sh
gsutil rm gs://my-unique-bucket-patiala-456/file.txt
```

✅ Delete all files in a folder (recursively)
```sh
gsutil rm -r gs://your-bucket-name/folder-name/
```

✅ Delete the entire bucket (including contents)
```sh
gsutil rm -r gs://my-unique-bucket-patiala-456
```

⚠️ -r is recursive — be careful, it deletes all contents.

🔍 BONUS: List Bucket Contents
```sh
gsutil ls gs://my-unique-bucket-patiala-456
```
