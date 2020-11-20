defmodule LiveViewTestWeb.MinioSigningTest do
  use ExUnit.Case, async: true

  alias LiveViewTestWeb.MinioSigning

  @doc """
  Example data generated with NodeJs minio client
  NODE JS OUTPUT

  policy:  PostPolicy {
  policy: {
    conditions: [ [Array], [Array], [Array], [Array], [Array], [Array] ],
    expiration: '2020-11-30T22:39:00.408Z'
  },
  formData: {
    key: 'test.png',
    bucket: 'uploads',
    'x-amz-date': '20201120T223922Z',
    'x-amz-algorithm': 'AWS4-HMAC-SHA256',
    'x-amz-credential': 'minio/20201120/us-east-1/s3/aws4_request'
  }
  }
  policy.policy:  {
  conditions: [
    [ 'eq', '$key', 'test.png' ],
    [ 'eq', '$bucket', 'uploads' ],
    [ 'content-length-range', 0, 209715200 ],
    [ 'eq', '$x-amz-date', '20201120T223922Z' ],
    [ 'eq', '$x-amz-algorithm', 'AWS4-HMAC-SHA256' ],
    [
      'eq',
      '$x-amz-credential',
      'minio/20201120/us-east-1/s3/aws4_request'
    ]
  ],
  expiration: '2020-11-30T22:39:00.408Z'
  }
  json:  {"conditions":[["eq","$key","test.png"],["eq","$bucket","uploads"],["content-length-range",0,209715200],["eq","$x-amz-date","20201120T223922Z"],["eq","$x-amz-algorithm","AWS4-HMAC-SHA256"],["eq","$x-amz-credential","minio/20201120/us-east-1/s3/aws4_request"]],"expiration":"2020-11-30T22:39:00.408Z"}
  base 64 policy:  eyJjb25kaXRpb25zIjpbWyJlcSIsIiRrZXkiLCJ0ZXN0LnBuZyJdLFsiZXEiLCIkYnVja2V0IiwidXBsb2FkcyJdLFsiY29udGVudC1sZW5ndGgtcmFuZ2UiLDAsMjA5NzE1MjAwXSxbImVxIiwiJHgtYW16LWRhdGUiLCIyMDIwMTEyMFQyMjM5MjJaIl0sWyJlcSIsIiR4LWFtei1hbGdvcml0aG0iLCJBV1M0LUhNQUMtU0hBMjU2Il0sWyJlcSIsIiR4LWFtei1jcmVkZW50aWFsIiwibWluaW8vMjAyMDExMjAvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJdXSwiZXhwaXJhdGlvbiI6IjIwMjAtMTEtMzBUMjI6Mzk6MDAuNDA4WiJ9
  {
  postURL: 'http://localhost:9000/uploads',
  formData: {
    key: 'test.png',
    bucket: 'uploads',
    'x-amz-date': '20201120T223922Z',
    'x-amz-algorithm': 'AWS4-HMAC-SHA256',
    'x-amz-credential': 'minio/20201120/us-east-1/s3/aws4_request',
    policy: 'eyJjb25kaXRpb25zIjpbWyJlcSIsIiRrZXkiLCJ0ZXN0LnBuZyJdLFsiZXEiLCIkYnVja2V0IiwidXBsb2FkcyJdLFsiY29udGVudC1sZW5ndGgtcmFuZ2UiLDAsMjA5NzE1MjAwXSxbImVxIiwiJHgtYW16LWRhdGUiLCIyMDIwMTEyMFQyMjM5MjJaIl0sWyJlcSIsIiR4LWFtei1hbGdvcml0aG0iLCJBV1M0LUhNQUMtU0hBMjU2Il0sWyJlcSIsIiR4LWFtei1jcmVkZW50aWFsIiwibWluaW8vMjAyMDExMjAvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJdXSwiZXhwaXJhdGlvbiI6IjIwMjAtMTEtMzBUMjI6Mzk6MDAuNDA4WiJ9',
    'x-amz-signature': 'db73f860d7dcc3ac96c79b98dcb4989834c1b0a78271694586dd17366af267aa'
  }
  }



  """
  test "Covert config to signed post form" do
    config = %{
      expire_seconds: 24 * 60 * 60 * 10,
      object: "test.png",
      bucket: "uploads",
      region: "us-east-1",
      access_key_id: "minio",
      secret_key: "minio123",
      host: "localhost",
      port: 9000,
      protocol: "http"
    }
    # TODO: fix zero seconds in real code
    {:ok, date_time, 0} = DateTime.from_iso8601("2020-11-20T22:39:22.408Z")
    expected = %{
      postURL: "http://localhost:9000/uploads",
      formData: %{
        key: "test.png",
        bucket: "uploads",
        "x-amz-date": "20201120T223922Z",
        "x-amz-algorithm": "AWS4-HMAC-SHA256",
        "x-amz-credential": "minio/20201120/us-east-1/s3/aws4_request",
        policy: "eyJjb25kaXRpb25zIjpbWyJlcSIsIiRrZXkiLCJ0ZXN0LnBuZyJdLFsiZXEiLCIkYnVja2V0IiwidXBsb2FkcyJdLFsiY29udGVudC1sZW5ndGgtcmFuZ2UiLDAsMjA5NzE1MjAwXSxbImVxIiwiJHgtYW16LWRhdGUiLCIyMDIwMTEyMFQyMjM5MjJaIl0sWyJlcSIsIiR4LWFtei1hbGdvcml0aG0iLCJBV1M0LUhNQUMtU0hBMjU2Il0sWyJlcSIsIiR4LWFtei1jcmVkZW50aWFsIiwibWluaW8vMjAyMDExMjAvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJdXSwiZXhwaXJhdGlvbiI6IjIwMjAtMTEtMzBUMjI6Mzk6MDAuNDA4WiJ9",
        "x-amz-signature": "db73f860d7dcc3ac96c79b98dcb4989834c1b0a78271694586dd17366af267aa"
      }
    }

    actual = MinioSigning.pre_signed_post_policy(config, date_time)
    assert actual == expected
  end
end