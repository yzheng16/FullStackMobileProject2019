module.exports = function(req, res) {
    const postBody = req.body.postBody;
    const userId = req.session.userId;
    console.info('creating a new post ' + postBody);
    

    //"imagefile" matchs the name in the input DOM name
    const file = req.file('imagefile')

    const options =
      { // This is the usual stuff
        adapter: require('skipper-better-s3')
      , key: 'AKIAID5COINGNV54CXRA'
      , secret: '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'
      , bucket: 'fullstack-bucket-y'
        // Let's use the custom s3params to upload this file as publicly
        // readable by anyone
      , s3params:
        { ACL: 'public-read'
        }
        // And while we are at it, let's monitor the progress of this upload
      , onProgress: progress => sails.log.verbose('Upload progress:', progress)
      }
 
      file.upload(options, async(err, files) => {
        if(err) { return res.serverError(err.toString())}

        //success
        const fileUrl = files[0].extra.Location
        // res.send(fileUrl);
        await Post.create({text: postBody, user: userId, imageUrl: fileUrl}).fetch();
        res.redirect('/post')
        })

        // res.send(record);
    
}