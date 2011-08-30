/*
 *
 *  ND2D - A Flash Molehill GPU accelerated 2D engine
 *
 *  Author: Lars Gerckens
 *  Copyright (c) nulldesign 2011
 *  Repository URL: http://github.com/nulldesign/nd2d
 *
 *
 *  Licence Agreement
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 * /
 */

package de.nulldesign.nd2d.materials {

    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    public class ASpriteSheetBase {

        protected var ctime:Number = 0.0;
        protected var otime:Number = 0.0;
        protected var interp:Number = 0.0;

        protected var frameIdx:uint = 0;

        protected var activeAnimation:SpriteSheetAnimation;
        protected var animationMap:Dictionary = new Dictionary();

        public var bitmapData:BitmapData;
        public var frameUpdated:Boolean = true;

        protected var fps:uint;

        protected var _textureWidth:Number;
        protected var _textureHeight:Number;

        public function get textureWidth():Number {
            return _textureWidth;
        }

        public function get textureHeight():Number {
            return _textureHeight;
        }

        protected var _spriteWidth:Number;
        protected var _spriteHeight:Number;

        public function get spriteWidth():Number {
            return _spriteWidth;
        }

        public function get spriteHeight():Number {
            return _spriteHeight;
        }

        protected var _frame:uint = 0;

        public function get frame():uint {
            return _frame;
        }

        public function set frame(value:uint):void {
            if(frame != value) {
                _frame = value;
                frameUpdated = true;
            }
        }

        public function ASpriteSheetBase() {
        }

        public function update(t:Number):void {

            if(!activeAnimation) return;

            ctime = t;

            // Update the timer part, to get time based animation
            interp += fps * (ctime - otime);
            if(interp >= 1.0) {
                frameIdx++;
                interp = 0;
            }

            if(activeAnimation.loop) {
                frameIdx = frameIdx % activeAnimation.numFrames;
            } else {
                frameIdx = Math.min(frameIdx, activeAnimation.numFrames - 1);
            }

            frame = activeAnimation.frames[frameIdx];

            otime = ctime;
        }

        public function addAnimation(name:String, keyFrames:Array, loop:Boolean, keyIsString:Boolean = false):void {
            animationMap[name] = new SpriteSheetAnimation(keyFrames, loop);
        }

        public function playAnimation(name:String, startIdx:uint = 0, restart:Boolean = false):void {
            if(restart || activeAnimation != animationMap[name]) {
                frameIdx = startIdx;
                activeAnimation = animationMap[name];
            }
        }

        public function clone():ASpriteSheetBase {
            return null;
        }

        public function getUVRectForFrame():Rectangle {
            return null;
        }
    }
}
