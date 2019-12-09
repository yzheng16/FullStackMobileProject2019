module.exports = async function (req, res) {
    const userId = req.session.userId;
    // console.info("user ID : " + userId)
    // await Post.destroy({});
    const allPost = await Post.find({user: userId})
                              .populate('user')
                              .sort("createdAt DESC");
    // Get JSON format for iOS
    if (req.wantsJSON) {
        return res.send(allPost)
    }
    // Get HTML format for website
    res.view('pages/post/home', {
        allPost
    })
}