Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbZALBGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbZALBGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 20:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZALBGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 20:06:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54551 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZALBGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 20:06:23 -0500
Message-ID: <496A9753.80802@cn.fujitsu.com>
Date: Mon, 12 Jan 2009 09:05:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: fix wrong English expression in comments
References: <496a3c51.09876e0a.03fe.7e80@mx.google.com>
In-Reply-To: <496a3c51.09876e0a.03fe.7e80@mx.google.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -103,7 +103,7 @@ struct inet_bind_bucket;
>  struct inet_timewait_sock {
>  	/*
>  	 * Now struct sock also uses sock_common, so please just
> -	 * don't add nothing before this first member (__tw_common) --acme
> +	 * don't add anything before this first member (__tw_common) --acme

They are the same meaning...

>  	 */
>  	struct sock_common	__tw_common;
>  #define tw_family		__tw_common.skc_family
