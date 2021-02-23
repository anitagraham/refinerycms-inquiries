const path = require('path');
const rootPath = path.resolve(__dirname, '..');
const Root = rootPath
const Src = path.resolve(rootPath, 'src')
const Vendor = path.resolve(rootPath, 'vendor')
const Dist = path.resolve(rootPath, 'dist')
module.exports = {Dist, Root,  Src, Vendor}
