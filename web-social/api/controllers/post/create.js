module.exports = async function(req, res) {
    const postBody = req.body.postBody;
    console.info('creating a new post ' + postBody);
    const userId = req.session.userId;
    await Post.create({text: postBody, user: userId});
    // res.send(record);
    res.redirect('/post')
}