import 'package:flutter/material.dart';
import 'package:turbo_ui/methods_extension/color_extension.dart';

const Color _kDefaultImageHighlightColor = const Color(0X40FFFFFF);

/// 带点击效果的图片框
/// `image` 图片源
/// 
/// `highlightImage` toch时的高亮图片
/// 
/// `borderRadius` 圆角
/// 
/// `width` 宽度
/// 
/// `height` 高度
/// 
/// `fit` 如何将图像铭刻到布局期间分配的空间 How to inscribe the image into the space allocated during layout.
/// 
/// `loadingBuilder`
/// 
/// `frameBuilder`
/// 
/// `alignment` 对齐方式
/// 
/// `imageRepeat`
/// 
/// `imageRepeat`
/// 
/// `colorBlendMode`
/// 
/// `filterQuality`
/// 
/// `splashColor` 水波纹颜色
/// 
/// `highlightColor` 高亮色
/// 
/// `onPressed`
class TurboImage extends StatefulWidget {
  TurboImage({
    Key key,
    @required this.image,
    this.highlightImage,
    this.borderRadius,
    this.width,
    this.height,
    this.fit,
    this.loadingBuilder,
    this.frameBuilder,
    this.alignment = Alignment.center,
    this.imageRepeat = ImageRepeat.noRepeat,
    this.colorBlendMode,
    this.filterQuality = FilterQuality.low,
    this.splashColor,
    this.highlightColor,
    this.onPressed,
  })  : assert(image != null),
        super(key: key);

  final ImageProvider image;
  final ImageProvider highlightImage;
  final BorderRadius borderRadius;
  final double width;
  final double height;
  final BoxFit fit;
  final ImageLoadingBuilder loadingBuilder;
  final ImageFrameBuilder frameBuilder;
  final AlignmentGeometry alignment;
  final ImageRepeat imageRepeat;
  final BlendMode colorBlendMode;
  final FilterQuality filterQuality;
  final Color splashColor;
  final Color highlightColor;
  final VoidCallback onPressed;

  @override
  State<TurboImage> createState() => _TurboImageState();
}

class _TurboImageState extends State<TurboImage> {
  ImageProvider _contentImage;

  @override
  void initState() {
    super.initState();
    _contentImage = widget.image;
  }

  void _handleHighlightChanged(bool highlight) {
    if (widget.highlightImage != null) {
      if (highlight) {
        setState(() {
          _contentImage = widget.highlightImage;
        });
      } else {
        setState(() {
          _contentImage = widget.image;
        });
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    Color _curHighlightColor = widget.highlightColor ?? _kDefaultImageHighlightColor;
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Container(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image(
                image: _contentImage,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                loadingBuilder: widget.loadingBuilder,
                frameBuilder: widget.frameBuilder,
                alignment: widget.alignment,
                repeat: widget.imageRepeat,
                colorBlendMode: widget.colorBlendMode,
                filterQuality: widget.filterQuality,
              )
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onHighlightChanged: _handleHighlightChanged,
                  splashColor: widget.splashColor.toARGBColor(alpha:80),
                  highlightColor: _curHighlightColor.toARGBColor(alpha:50),
                  onTap: widget.onPressed,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
