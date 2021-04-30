#!/usr/bin/python

import json
import base64
import os
import os.path
import urllib.parse
import urllib.request

def run_request(req: urllib.request.Request) -> str:
	with urllib.request.urlopen(req) as res:
		return res.read().decode("utf-8")

def get_meta(path: str) -> str:
	return run_request(urllib.request.Request(
		f"http://metadata.google.internal/computeMetadata/v1/{path}",
		None,
		{"Metadata-Flavor": "Google"},
	))

def get_certs_bucket() -> str:
	return get_meta("instance/attributes/certs-bucket")

def get_certs_name() -> str:
	return get_meta("instance/attributes/certs-name")

def get_token() -> str:
	res = get_meta("instance/service-accounts/default/token")
	data = json.loads(res)
	return data["access_token"]

def download(token: str, bucket: str, object: str) -> str:
	quotedObj = urllib.parse.quote_plus(object)

	return run_request(urllib.request.Request(
		f"https://storage.googleapis.com/download/storage/v1/b/{bucket}/o/{quotedObj}?alt=media",
		None,
		{
			"Authorization": f"Bearer {token}",
		},
	))

def sync_certificates(mapping: dict) -> None:
	token = get_token()
	bucket = get_certs_bucket()
	name = get_certs_name()

	for obj, dst in mapping.items():
		objName = f"{name}/{obj}"
		dstPath = os.path.join(dst, objName)
		os.makedirs(os.path.dirname(dstPath), exist_ok=True)

		with open(dstPath, "w") as file:
			file.write(download(token, bucket, objName))

sync_certificates({
	"privkey.pem": "/var/opt/ssl",
	"fullchain.pem": "/var/opt/ssl",
})
