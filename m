Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab0BXBiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:38:15 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36412 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0BXBiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:38:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fRrLwxFkMoNY6c87lUzbe6QmTAUaF2WfoU+piIK/QT6Nlc0tMoNq/452AuzEBYjvmF
         5+t2t5gum7tMENfgZw/VkZsYa0tXcCjNX+Nf+qg+/7l3yn9EGN1c7ZTHFgB/46/L15kF
         dkOI51kw0RBerPibxURJMFLRPEM5Nhv9QQpkw=
Message-ID: <4B8482FB.1070506@gmail.com>
Date: Wed, 24 Feb 2010 09:38:03 +0800
From: Huang Shijie <shijie8@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH - next] MAINTAINERS: Telegent tlg2300 section fix
References: <1266944900.9265.28.camel@Joe-Laptop.home>
In-Reply-To: <1266944900.9265.28.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> linux-next commit 2ff8223957d901999bf76aaf2c6183e33a6ad14e
> exposes an infinite loop defect in scripts/get_maintainer.pl
>
> Fix the incorrect format of the MAINTAINERS "M:" entries.
>
> Signed-off-by: Joe Perches<joe@perches.com>
>    
thanks ,
acked by : Huang Shijie
> ---
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 57305f6..e633460 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4775,13 +4775,12 @@ F:	drivers/media/video/*7146*
>   F:	include/media/*7146*
>
>   TLG2300 VIDEO4LINUX-2 DRIVER
> -M 	Huang Shijie	<shijie8@gmail.com>
> -M 	Kang Yong	<kangyong@telegent.com>
> -M 	Zhang Xiaobing	<xbzhang@telegent.com>
> +M:	Huang Shijie<shijie8@gmail.com>
> +M:	Kang Yong<kangyong@telegent.com>
> +M:	Zhang Xiaobing<xbzhang@telegent.com>
>   S:	Supported
>   F:	drivers/media/video/tlg2300
>
> -
>   SC1200 WDT DRIVER
>   M:	Zwane Mwaikambo<zwane@arm.linux.org.uk>
>   S:	Maintained
>
>
>
>    

