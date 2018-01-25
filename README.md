# MultiImagePicker
## 使用方法
1. 使用前在info.plist前加入权限Privacy - Photo Library Usage Description    Photo Library Additions Usage Description
2. 引入MultiAlbumController.h并实现代理MultiAlbumControllerDelegate，方法- (void)multiImagePickComplete:(NSMutableArray *)selectedAssets,selectedAssets即为选中的图片数组
3. 预览选中的图片引入MultiImageSelectedBrowserController.h，传入选中的selectedAssets和图片对应的index
