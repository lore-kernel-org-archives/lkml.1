Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbXHVKYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbXHVKYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXHVKYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:24:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:13103 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbXHVKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eBrPEBkvZXj31NG5v0uLAS2+3BDtWwlUo4oJf3/XsxANWwP5d6D9SaqVODte5KF28LzrIa0wCiK8kZmaJJ6ESSE1gaoRddnHy+gS33Joa3X97pvv6WTRPMT/GH0l5wMbX4WOKTE22JwU4+o+vmEDtfI3oDUEVGxHe/89If4Rkso=
Message-ID: <6bffcb0e0708220323w5592df25n9c21c7e3aca1dbfb@mail.gmail.com>
Date: Wed, 22 Aug 2007 12:23:58 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH] MAINTAINTERS: use our mail list as Blackfin arch maintainters.
Cc: joe@perches.com, yi.li@analog.com, vivi.li@analog.com,
       torvalds@linux-foundation.org, sonic.zhang@analog.com,
       roy.huang@analog.com, robin.getz@analog.com,
       michael.hennerich@analog.com, michael.frysinger@analog.com,
       marc.hoffman@analog.com, linux-kernel@vger.kernel.org,
       jie.zhang@analog.com, grace.pan@analog.com, bernd.schmidt@analog.com,
       akpm@linux-foundation.org
In-Reply-To: <1187777706.24914.2.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff904.ANPWrqncsP8VpmBH%joe@perches.com>
	 <1187777706.24914.2.camel@roc-desktop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 22/08/07, Bryan Wu <bryan.wu@analog.com> wrote:
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  MAINTAINERS |   28 ----------------------------
>  1 files changed, 0 insertions(+), 28 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e4dde7f..55ac8e5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -717,34 +717,6 @@ M: rpurdie@rpsys.net
>  S:     Maintained
>
>  BLACKFIN ARCHITECTURE
> -P:     Aubrey Li
> -M:     aubrey.li@analog.com
> -P:     Bernd Schmidt
> -M:     bernd.schmidt@analog.com
> -P:     Bryan Wu
> -M:     bryan.wu@analog.com
> -P:     Grace Pan
> -M:     grace.pan@analog.com
> -P:     Marc Hoffman
> -M:     marc.hoffman@analog.com
> -P:     Michael Hennerich
> -M:     michael.hennerich@analog.com
> -P:     Mike Frysinger
> -M:     michael.frysinger@analog.com
> -P:     Jerry Zeng
> -M:     jerry.zeng@analog.com
> -P:     Jie Zhang
> -M:     jie.zhang@analog.com
> -P:     Robin Getz
> -M:     robin.getz@analog.com
> -P:     Roy Huang
> -M:     roy.huang@analog.com
> -P:     Sonic Zhang
> -M:     sonic.zhang@analog.com
> -P:     Vivi Li
> -M:     vivi.li@analog.com
> -P:     Yi Li
> -M:     yi.li@analog.com
>  L:     uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)

It is subscribers-only - I do not want to subscribe list only for
sending/forwarding messages/bug reports/known regressions weekly
newsletter.

>  W:     http://blackfin.uclinux.org
>  S:     Supported

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
