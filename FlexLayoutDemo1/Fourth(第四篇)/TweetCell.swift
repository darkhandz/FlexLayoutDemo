//
//  TweetCell.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/18.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import UIKit
import FlexLayout
import Kingfisher


class TweetCell: UITableViewCell {
    
    fileprivate let avatarImgV = UIImageView()
    fileprivate let nameLabel = UILabel()
    fileprivate let userIntroLabel = UILabel()
    fileprivate let followBtn = UIButton()
    fileprivate let contentLabel = UILabel()
    fileprivate let topicBtn = UIButton()
    fileprivate let singleImgV = UIImageView()
    fileprivate let imagesContainer = UIView()
    fileprivate var imgs = [UIImageView]()
    fileprivate var likeBtn: UIButton!
    fileprivate var commentBtn: UIButton!
    fileprivate var shareBtn: UIButton!
    fileprivate var item: TweetItem?
    
    /// 9图的间隙
    fileprivate let imageSpacing: CGFloat = 4
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    
    private func configUI() {
        selectionStyle = .none
        
        let menuBtn = UIButton()
        menuBtn.setTitle("···", for: .normal)
        menuBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        menuBtn.setTitleColor(.gray, for: .normal)
        
        followBtn.setTitle("+ 关注", for: .normal)
        followBtn.setTitleColor(.lightGray, for: .normal)
        followBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        followBtn.layer.cornerRadius = 2
        followBtn.layer.borderColor = UIColor.lightGray.cgColor
        followBtn.layer.borderWidth = 0.5
        
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = UIColor(white: 0.3, alpha: 1)
        userIntroLabel.font = UIFont.systemFont(ofSize: 12)
        userIntroLabel.textColor = UIColor(white: 0.6, alpha: 1)
        
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = UIColor(white: 0.3, alpha: 1)
        contentLabel.numberOfLines = 0
        
        singleImgV.backgroundColor = UIColor.lightGray

        topicBtn.setTitleColor(UIColor(0, 0.5, 1, 1), for: .normal)
        topicBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        topicBtn.layer.cornerRadius = 12.5
        topicBtn.layer.borderColor = UIColor(0, 0.5, 1, 1).cgColor
        topicBtn.layer.borderWidth = 1
        
        // 生成9个图片view
        imgs = (0..<9).map {
            let imgv = UIImageView()
            imgv.tag = $0
            return imgv
        }
        
        likeBtn = createButton(title: "9", icon: "icon_like")
        commentBtn = createButton(title: "1", icon: "icon_comment")
        shareBtn = createButton(title: "", icon: "icon_share")
        
        
        contentView.flex.paddingHorizontal(13).define { flex in
            flex.addItem().direction(.row).alignItems(.center).marginTop(13).define{ flex in
                flex.addItem(avatarImgV).size(40)
                flex.addItem().justifyContent(.spaceBetween).alignSelf(.stretch).marginHorizontal(10)
                    .paddingVertical(2).grow(1).shrink(1).define{ flex in
                    flex.addItem(nameLabel)
                    flex.addItem(userIntroLabel)
                }
                flex.addItem(followBtn).height(20).paddingHorizontal(6)
                flex.addItem(menuBtn).marginLeft(5).marginRight(-5)
            }
            flex.addItem(contentLabel).marginTop(13)
            flex.addItem(singleImgV).marginTop(10)
            flex.addItem(imagesContainer).direction(.row).wrap(.wrap).marginRight(-4)
                .marginLeft(1).marginTop(10).define{ flex in
                // 每个图片view宽度
                let imgWidth = CGFloat(Int(ScreenWidth - 2 * 13/*左右外边距*/ - 2 * imageSpacing) / 3/*列数*/)
                for imgV in imgs {
                    flex.addItem(imgV).width(imgWidth).height(imgWidth).marginRight(imageSpacing)
                        .marginTop(imageSpacing).backgroundColor(.lightGray)
                }
            }
            flex.addItem(topicBtn).alignSelf(.start).height(25).marginTop(12).paddingHorizontal(10)
            // 分隔线
            flex.addItem().height(1).marginTop(13).backgroundColor(UIColor(white: 0.92, alpha: 1))
            flex.addItem().direction(.row).justifyContent(.spaceAround).height(38).define{ flex in
                flex.addItem(likeBtn)
                flex.addItem(commentBtn)
                flex.addItem(shareBtn)
            }
        }
    }
    
    
    func configWith(_ item: TweetItem) {
        // 同样的item不需要再次计算(实际生产中还要考虑item内部内容变化的情况)
        if let exist = self.item, exist === item { print("skip"); return }        
        let roundProcessor = RoundCornerImageProcessor(cornerRadius: 20,
                                                       targetSize: CGSize(width: 40, height: 40))
        avatarImgV.kf.setImage(with: URL(string: item.user?.avatarLarge ?? ""),
                               options: [.transition(.fade(0.3)),
                                         .scaleFactor(UIScreen.main.scale),
                                         .processor(roundProcessor),
                                         .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        nameLabel.text = item.user?.username
        let job = item.user?.jobTitle ?? ""
        let company = item.user?.company ?? ""
        if job.isEmpty && company.isEmpty {
            userIntroLabel.text = item.createdAt
        } else {
            userIntroLabel.text = [job, company].joined(separator: " @ ")
                .trimmingCharacters(in: CharacterSet(charactersIn: " @"))
        }
        let isFollowed = item.user?.currentUserFollowed ?? false
        followBtn.setTitle(isFollowed ? "已关注" : "+ 关注", for: .normal)
        
        // 默认隐藏图片容器和里面所有图片
        imagesContainer.flex.isLayoutAndShow = false
        imgs.forEach{ $0.flex.isLayoutAndShow = false }
        singleImgV.flex.isLayoutAndShow = false
        
        if item.pictures.isEmpty {
            // 没有图片

        } else if item.pictures.count == 1 {
            // 1张图片
            singleImgV.flex.isLayoutAndShow = true
            let url = item.pictures[0]
            let key = url//.md5
            // 提取宽高尺寸
            if let size = item.picsSize[key] {
                singleImgV.flex.width(size.width).height(size.height)
            } else {
                let widths = url.regexFind(pattern: "w=([0-9]+)", atGroupIndex: 1)
                let heights = url.regexFind(pattern: "h=([0-9]+)", atGroupIndex: 1)
                // 重新计算图片尺寸
                if let width = widths.first, let height = heights.first, let wI = Int(width), let hI = Int(height) {
                    let (w, h) = scaleSize(CGSize(width: CGFloat(wI), height: CGFloat(hI)),
                                           toMax: CGSize(width: ScreenWidth * 0.65, height: 170))
                    singleImgV.flex.width(w).height(h)
                    // 缓存起来
                    item.picsSize[key] = CGSize(width: w, height: h)
                }
            }
            singleImgV.kf.setImage(with: URL(string: url), options: [.transition(.fade(0.3)), .onlyLoadFirstFrame])
        } else if item.pictures.count == 4 {
            // 4张图片
            if item.pictures.count != (self.item?.pictures.count ?? 0) {
                imagesContainer.flex.marginRight(0)
            }
            setupImages(from: item)
        } else {
            // 多张图片
            if item.pictures.count != (self.item?.pictures.count ?? 0) {
                imagesContainer.flex.marginRight(-4)
            }
            setupImages(from: item)
        }
        
        // 默认隐藏并且不布局话题按钮
        topicBtn.flex.isLayoutAndShow = false
        if let topicTitle = item.topic?.title {
            topicBtn.flex.isLayoutAndShow = true
            topicBtn.setTitle(topicTitle, for: .normal)
        }
        
        // 先取一下是否有缓存
        if let attrText = item.attributedText {
            contentLabel.attributedText = attrText
        } else {
            let targetStr: String
            if item.content.count <= 120 {
                targetStr = item.content
            } else {
                let start = item.content.startIndex
                let end = item.content.index(item.content.startIndex, offsetBy: 120)
                targetStr = String(item.content[start..<end]) + "..."
            }
            // 替换内容里面的链接
            let content = replaceLinkIn(text: targetStr,
                                        font: UIFont.systemFont(ofSize: 16),
                                        textColor: UIColor(white: 0.3, alpha: 1))
            // 行距
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 4
            content.addAttributes([.paragraphStyle : style], range: NSRange(location: 0, length: content.length))
            item.attributedText = content
            contentLabel.attributedText = content
        }
        contentLabel.flex.markDirty()
        self.item = item
        setNeedsLayout()
    }
    
    private func setupImages(from item: TweetItem) {
        imagesContainer.flex.isLayoutAndShow = true
        for (imgV, url) in zip(imgs, item.pictures) {
            imgV.flex.isLayoutAndShow = true
            imgV.kf.setImage(with: URL(string: url), options: [.transition(.fade(0.3)), .onlyLoadFirstFrame])
        }
    }

    
    func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.frame.size = size
        layout()
        return contentView.frame.size
    }
    
    override func layoutSubviews() {
        contentView.frame.size = bounds.size
        layout()
    }

}





extension TweetCell {
    
    private func createButton(title: String, icon: String) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor(white: 0.75, alpha: 1), for: .normal)
        btn.setImage(UIImage(named: icon), for: .normal)
        return btn
    }
    
    /// 把origSize按比例缩放到maxSize限定的范围内
    private func scaleSize(_ origSize: CGSize, toMax maxSize: CGSize) -> (CGFloat, CGFloat) {
        var w = origSize.width ; var h = origSize.height
        let maxWidth = ScreenWidth * 0.65
        let maxHeight: CGFloat = 170
        let ratio = w / h
        if w > h, w > maxWidth {
            w = maxWidth
            h = w / ratio
        } else if h > w, h > maxWidth {
            h = maxHeight
            w = h * ratio
        }
        return (floor(w), floor(h))
    }
    
    private func replaceLinkIn(text: String, font: UIFont, textColor: UIColor) -> NSMutableAttributedString {
        let content = NSMutableAttributedString(string: text)
        // 字体
        let fontAttr: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: textColor]
        content.addAttributes(fontAttr, range: NSRange(location: 0, length: content.length))
        let urls = text.findAllURLs()
        for (url, subRange) in urls.reversed() {
            // 去掉原始链接
            content.replaceCharacters(in: subRange, with: "")
            // 准备替换的字符串
            let icon = NSTextAttachment()
            icon.image = UIImage(named: "icon_link")
            icon.bounds = CGRect(x: 0, y: font.descender, width: 14, height: 14)
            let attr = NSMutableAttributedString()
            attr.append(NSAttributedString(attachment: icon))
            attr.append(NSAttributedString(string: "网页链接"))
            attr.addAttributes([.foregroundColor: UIColor(red: 0.09, green: 0.49, blue: 1, alpha: 1)],
                              range: NSRange(location: 0, length: attr.length))
            // 插入到被替换的原始链接的起始位置
            content.insert(attr, at: subRange.location)
        }
        return content
    }
}




extension String {
    /// 正则查找，返回匹配结果数组，可以指定返回匹配的第groupIndex组
    func regexFind(pattern: String, atGroupIndex index: Int = 0, options: NSRegularExpression.Options = []) -> [String] {
        var result = [String]()
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        regex.enumerateMatches(in: self, options: [], range: NSRange(location: 0, length: self.count)) {
            (checkingRes, flag, shouldStop) in
            guard let range = checkingRes?.range(at: index) else { return }
            let start = self.index(self.startIndex, offsetBy: range.lowerBound)
            let end = self.index(self.startIndex, offsetBy: range.upperBound)
            let substr = String(self[start..<end])
            result.append(substr)
        }
        return result
    }
    
    /// 搜索所有URL
    func findAllURLs() -> [(String, NSRange)] {
        let pattern = "(?:(?:https?|ftp)://)(?:\\S+(?::\\S*)?@)?(?:(?!(?:10|127)(?:\\.\\d{1,3}){3})(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))\\.?)(?::\\d{2,5})?(?:[/?#]\\S*)?"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        let matches = regex.matches(in: self, options: [],
                                    range: NSRange(location: 0, length: self.count))
        var result = [(String, NSRange)]()
        for m in matches {
            let start = self.index(self.startIndex, offsetBy: m.range.lowerBound)
            let end = self.index(self.startIndex, offsetBy: m.range.upperBound)
            let substr = String(self[start..<end])
            result.append((substr, m.range))
        }
        return result
    }
}




extension Flex {
    /// 是否进行布局计算及显示
    public var isLayoutAndShow: Bool {
        set {
            isIncludedInLayout = newValue
            self.view?.isHidden = !newValue
        }
        get {
            return isIncludedInLayout && (self.view?.isHidden ?? false)
        }
    }
}
