/////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2007 Advanced Flex Project http://code.google.com/p/advancedflex/. 
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package advancedflex.resource {
	
	import advancedflex.io.format.Base64Decoder;
	import advancedflex.io.format.Base64Encoder;
	
	import flash.utils.*;
	
	import mx.resources.ResourceBundle;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	//TODO uncheck
	public class Properties implements IExternalizable {
		public function Properties() {
			content = new Object();
		}
		protected var content:Object;
		
		public function put(key:String, value:String):void {
			content[key] = value;
		}
		
		public function putNumber(key:String, value:Number):void {
			content[key] = value;
		}
		
		public function putBoolean(key:String, value:Boolean):void {
			content[key] = value;
		}
		
		public function putArray(key:String, value:Array, splitCode:String = ","):void {
			content[key] = value.join(splitCode);
		}
		
		public function putClass(key:String, value:Class):void {
			content[key] = getQualifiedClassName(value);
		}
		
		public function putDate(key:String, value:Date):void {
			content[key] = value.toString();
		}
		
		public function putNamespace(key:String, value:Namespace):void {
			content[key] = value.uri;
		}
		public function putBinary(key:String, value:ByteArray):void {
			content[key] = Base64Encoder.encodeByteArray(value);
		}
		public function putObject(key:String, value:*):void {
			if(value is String) {
				put(key, value);
			}else if(value is Number) {
				putNumber(key, value);
			}else if(value is Number) {
				putNumber(key, value);
			}else if(value is Boolean) {
				putBoolean(key, value);
			}else if(value is Array) {
				putArray(key, value);
			}else if(value is Class) {
				putClass(key, value);
			}else if(value is Date) {
				putDate(key, value);
			}else if(value is Namespace) {
				putNamespace(key, value);
			}else if(value is QName) {
				putQName(key, value);
			}else if(value is RegExp) {
				putRegExp(key, value);
			}else if(value is XML) {
				putXML(key, value);
			}else if(value is XMLList) {
				putXMLList(key, value);
			}else{//Other
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject(value);
				content[key] = Base64Encoder.encodeByteArray(bytes);
			}
		}
		
		public function putQName(key:String, value:QName):void {
			content[key] = value.toString()
		}
		
		public function putRegExp(key:String, value:RegExp):void {
			content[key] = value.source;
		}
		
		public function putXML(key:String, value:XML):void {
			content[key] = value.toXMLString();
		}
		
		public function putXMLList(key:String, value:XMLList):void {
			content[key] = value.toXMLString();
		}
		///////////////////////
		public function getString(key:String, ...args):String {
			return StringUtil.substitute( content[key], args );
		}
		
		public function getNumber(key:String, ...args):Number {
			return Number( StringUtil.substitute( content[key], args ) );
		}
		
		public function getBoolean(key:String, ...args):Boolean {
			return Boolean( StringUtil.substitute( content[key], args ) );
		}
		public function getArray(key:String,splitCode:String = ",", ...args):Array {
			return StringUtil.substitute( content[key], args ).split(splitCode);
		}
		public function getClass(key:String, ...args):Class {
			return getDefinitionByName( StringUtil.substitute( content[key], args ) ) as Class;
		}
		public function getDate(key:String, ...args):Date {
			return new Date( StringUtil.substitute( content[key], args ) );
		}
		public function getNamespace(key:String, ...args):Namespace {
			return new Namespace( StringUtil.substitute( content[key], args ) );
		}
		public function getBinary(key:String, ...args):String {
			return StringUtil.substitute( Base64Decoder.decode(content[key]), args );
		}
		public function getObject(key:String, ...args):Object {
			return Base64Decoder.decodeToByteArray(content[key]).readObject();
		}
		public function getQName(key:String):QName {
			var str:String = content[key];
			var index:int = str.lastIndexOf("::");
			return new QName(str.substring(0, index), str.substr(index+1));
		}
		public function getRegExp(key:String, ...args):RegExp {
			var source:String = StringUtil.substitute( content[key], args );
			var lastDashIndex:int = source.lastIndexOf("/");
			return new RegExp( source.substring(1, lastDashIndex), source.substring(lastDashIndex + 1) )
		}
		public function getXML(key:String, ...args):String {
			return new XML( StringUtil.substitute( content[key], args ) );
		}
		public function getXMLList(key:String, ...args):String {
			return new XMLList( StringUtil.substitute( content[key], args ) );
		}
		public function hasKey(key:String):Boolean {
			return key in content;
		}
		
		public function hasValue(value:String):Boolean {
			for each(var i:* in content) {
				if(value == i) {
					return true;
				}
			}
			return false;
		}
		public function deleteKey(key:String):Boolean {
			return delete content[key];
		}
		public function clone():Properties {
			return ObjectUtil.copy(this) as Properties;
		}
		public function valueOf(value:Object):void {
			if(value is IDataInput) {
				streamOf(value as IDataInput);
			}else if(value is ResourceBundle){
				resourceBundleOf(value as ResourceBundle);
			}else if(value is String) {
				stringOf(value as String);
			}else{
				stringOf(String(value));
			}
		}
		protected static const COMMENT:RegExp = /^#.*$/gm;
		public function stringOf(src:String, newline:String = ""):void {
			newline = newline ? newline : Newline.defaultNewline;
			src = src.replace(COMMENT, "");
			var item:Array = src.split(newline);
			for each(var i:String in item) {
				var eqIndex:int = i.indexOf("=");
				put(i.substring(0, eqIndex), i.substring(eqIndex + 1));
			}
		}
		public function streamOf(stream:IDataInput, length:int = 0):void {
			if(length<=0) {
				stringOf(stream.readUTF());
			}else{
				stringOf(stream.readUTFBytes(length));
			}
		}
		public function resourceBundleOf(resource:ResourceBundle):void {
			content = new ResourceBundleWrapper(resource);
		}
		public static const OUT_UTF:int = 0;
		public static const OUT_UTF_BYTES:int = 1;
		public function writeStream(stream:IDataOutput, mode:int = 0):void {
			switch(mode) {
				case OUT_UTF:
					stream.writeUTF(toString());
				case OUT_UTF_BYTES:
					stream.writeUTFBytes(toString());
				default:
					throw new ReferenceError("You entered unknown mode:<" + mode 
											+ ">.Mode must be OUT_UTF or OUT_UTF_BYTES.");
			}
		}
		public function toString(newline:String = ""):String {
			if(newline == "") {
				newline = Newline.defaultNewline;
			}
			var result:String = "";
			for(var i:String in content) {
				result += i + "=" + content[i] + newline;
			}
			return result;
		}
		public function clear():void {
			content = new Object();
		}
		public function readExternal(input:IDataInput):void {
			streamOf(input);
		}
		public function writeExternal(output:IDataOutput):void {
			writeStream(output, OUT_UTF);
		}
	}
}