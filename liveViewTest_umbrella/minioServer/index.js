const Minio = require("minio");
const app = require("express")();

const minioClient = new Minio.Client({
    endPoint: 'localhost',
    port: 9000,
    useSSL: false,
    accessKey: 'minio',
    secretKey: "minio123"
});

app.get('/:object', (req, res) => {

    const policy = minioClient.newPostPolicy()
    policy.setKey(req.params.object)
    policy.setBucket("uploads")

    const expires = new Date
    expires.setSeconds(24 * 60 * 60 * 10) //10 days
    policy.setExpires(expires)

    policy.setContentLengthRange(0, 1024*1024 * 200) // Min upload length is 0B Max upload size is 200MB

    minioClient.presignedPostPolicy(policy, function(e, data) {
      if (e) {
          return console.log(e)
      }
      console.log(data);
      res.json(data);
    });
});

app.listen(3000, () => {
    console.log("server started")
})