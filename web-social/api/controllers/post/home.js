module.exports = async function (req, res) {
    // const userId = req.session.userId;
    // console.info("user ID : " + userId)
    // await Post.destroy({});
    const allPost = await Post.find({})
                              .populate('user')
                              .sort("createdAt DESC");
    res.view('pages/post/home', {
        allPost
    })
}