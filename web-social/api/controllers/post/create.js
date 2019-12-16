module.exports = async function(req, res) {
    const postBody = req.body.postBody;
    console.info('creating a new post ' + postBody);

    //imagefile matchs the name in the input DOM name
    const file = req.file('imagefile')

    // I want to upload my file above
    file.upload({
        adapter: require('skipper-s3'),
        key: 'S3 Key',
        secret: 'S3 Secret',
        bucket: 'Bucket Name'
    }, function (err, filesUploaded) {

        if (err) return res.serverError(err);

        return res.ok({
            files: filesUploaded,
            textParams: req.allParams()
        });
    });

    // const userId = req.session.userId;
    // await Post.create({text: postBody, user: userId});
    // // res.send(record);
    // res.redirect('/post')
}