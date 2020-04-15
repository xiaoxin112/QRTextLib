window.__require = function e(t, n, r) {
  function s(o, u) {
    if (!n[o]) {
      if (!t[o]) {
        var b = o.split("/");
        b = b[b.length - 1];
        if (!t[b]) {
          var a = "function" == typeof __require && __require;
          if (!u && a) return a(b, !0);
          if (i) return i(b, !0);
          throw new Error("Cannot find module '" + o + "'");
        }
        o = b;
      }
      var f = n[o] = {
        exports: {}
      };
      t[o][0].call(f.exports, function(e) {
        var n = t[o][1][e];
        return s(n || e);
      }, f, f.exports, e, t, n, r);
    }
    return n[o].exports;
  }
  var i = "function" == typeof __require && __require;
  for (var o = 0; o < r.length; o++) s(r[o]);
  return s;
}({
  main: [ function(require, module, exports) {
    "use strict";
    cc._RF.push(module, "52444xyMU5I04Gj3kHc4DFh", "main");
    "use strict";
    cc.Class({
      extends: cc.Component,
      ctor: function ctor() {
        this.zoneSkeleton = null;
        this.zoneName = "";
        this.isZoneLoop = false;
        this.emojiSkeleton = null;
        this.emojiName = "";
        this.isEmojiloop = false;
        var self = this;
        window.loadEmojiData = function() {
          cc.log("loadEmojiData");
          self.loadEmojiData();
        };
        window.clearEmoji = function() {
          cc.log("clearEmoji");
          self.clearEmoji();
        };
        window.setEmojiPosition = function(x, y) {
          cc.log("setEmojiPosition ----");
          self.setEmojiPosition(x, y);
        };
        window.setEmojiVisible = function(type) {
          0 == type ? self.setEmojiVisible(false) : self.setEmojiVisible(true);
        };
        window.setEmojiThinkAction = function(loopType) {
          cc.log("setEmojiThinkAction");
          self.isEmojiloop = 0 != loopType;
          self.setEmojiThinking();
        };
        window.loadZoneNiuData = function() {
          cc.log("loadZoneNiuData");
          self.loadZoneNiuData();
        };
        window.clearZoneNiu = function() {
          cc.log("clearZoneNiu");
          self.clearZoneNiu();
        };
        window.setZonePosition = function(x, y) {
          cc.log("setZonePosition ----");
          self.setZonePosition(x, y);
        };
        window.setZoneVisible = function(type) {
          0 == type ? self.setZoneVisible(false) : self.setZoneVisible(true);
        };
        window.setDiantouAction = function(loopType) {
          cc.log("setDiantouAction");
          self.isZoneLoop = 0 != loopType;
          self.setDiantouAction();
        };
      },
      properties: {
        zonePlayer: cc.Node,
        emojiPlayer: cc.Node
      },
      onLoad: function onLoad() {
        cc.debug.setDisplayStats(false);
        var self = this;
        this.emojiSkeleton = this.emojiPlayer.getComponent(sp.Skeleton);
        this.emojiSkeleton.setCompleteListener(function() {
          cc.log("emojiSkeleton play once");
          self.isEmojiloop || self.emojiCallbackToNative(self.emojiName);
        });
        this.zoneSkeleton = this.zonePlayer.getComponent(sp.Skeleton);
        this.zoneSkeleton.setCompleteListener(function() {
          cc.log("zoneSkeleton play once");
          self.isZoneLoop || self.zoneCallbackToNative(self.zoneName);
        });
      },
      emojiCallbackToNative: function emojiCallbackToNative(name) {
        cc.sys.isNative && cc.sys.os == cc.sys.OS_IOS ? jsb.reflection.callStaticMethod("RootViewController", "emojiAniCallback:", name) : cc.sys.isNative && cc.sys.os == cc.sys.OS_ANDROID && jsb.reflection.callStaticMethod("org/cocos2dx/javascript/AppActivity", "emojiAniCallback", "(Ljava/lang/String;)V", name);
      },
      loadEmojiData: function loadEmojiData() {
        var self = this;
        cc.loader.loadRes("manniuSpines/manniu_shikao/Thinking", sp.SkeletonData, function(err, res) {
          if (err) {
            console.log("\u9519\u8bef");
            cc.error(err);
          }
          self.emojiSkeleton.skeletonData = res;
        });
      },
      setEmojiPosition: function setEmojiPosition(x, y) {
        this.emojiPlayer.setPosition(x, y);
      },
      clearEmoji: function clearEmoji() {
        this.emojiSkeleton.clearTracks();
        this.isEmojiloop = false;
        this.loadEmojiData();
      },
      setEmojiVisible: function setEmojiVisible(isVisible) {
        this.emojiPlayer.active = isVisible;
      },
      setEmojiThinking: function setEmojiThinking() {
        this.emojiName = "emojiThinking";
        this.emojiSkeleton.setAnimation(0, "sikao", this.isEmojiloop);
      },
      zoneCallbackToNative: function zoneCallbackToNative(name) {
        cc.sys.isNative && cc.sys.os == cc.sys.OS_IOS ? jsb.reflection.callStaticMethod("RootViewController", "zoneAniCallback:", name) : cc.sys.isNative && cc.sys.os == cc.sys.OS_ANDROID && jsb.reflection.callStaticMethod("org/cocos2dx/javascript/AppActivity", "zoneAniCallback", "(Ljava/lang/String;)V", name);
      },
      loadZoneNiuData: function loadZoneNiuData() {
        var self = this;
        cc.loader.loadRes("manniuSpines/diantou/biaoqingbao", sp.SkeletonData, function(err, res) {
          if (err) {
            console.log("\u9519\u8bef");
            cc.error(err);
          }
          self.zoneSkeleton.skeletonData = res;
        });
      },
      setZonePosition: function setZonePosition(x, y) {
        this.zonePlayer.setPosition(x, y);
      },
      clearZoneNiu: function clearZoneNiu() {
        this.zoneSkeleton.clearTracks();
        this.isZoneLoop = false;
        this.loadZoneNiuData();
      },
      setZoneVisible: function setZoneVisible(isVisible) {
        this.zonePlayer.active = isVisible;
      },
      setDiantouAction: function setDiantouAction() {
        this.zoneName = "diantou";
        this.zoneSkeleton.setAnimation(0, "diantou", this.isZoneLoop);
      }
    });
    cc._RF.pop();
  }, {} ]
}, {}, [ "main" ]);