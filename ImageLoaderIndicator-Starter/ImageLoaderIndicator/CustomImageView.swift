//
//  CustomImageView.swift
//  ImageLoaderIndicator
//
//  Created by Mohamed on 28/02/2015.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

let progressindicatorView = CircularLoaderView(frame: CGRectZero)
@IBDesignable
class CustomImageView: UIImageView {
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    addSubview(progressindicatorView)
    progressindicatorView.frame = bounds
    progressindicatorView.autoresizingMask = .FlexibleWidth | .FlexibleHeight;
    let url = NSURL(string: "http://www.raywenderlich.com/wp-content/uploads/2015/02/mac-glasses.jpeg")
    sd_setImageWithURL(url, placeholderImage: nil, options: .CacheMemoryOnly, progress: {
      [weak self]
      (receivedSize, expectedSize) -> Void in
      progressindicatorView.progress = CGFloat(receivedSize)/CGFloat(expectedSize)
      }) {
        [weak self]
        (image, error, _, _) -> Void in
        progressindicatorView.reveal()
    }
  }
  
}
