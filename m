Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0BDSZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:25:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508Ab0BDSZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:25:52 -0500
Date: Thu, 4 Feb 2010 10:24:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Richard Purdie <rpurdie@openedhand.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       trivial <trivial@kernel.org>
Subject: Re: [PATCH] LZO: update email address
Message-Id: <20100204102431.82075c66.akpm@linux-foundation.org>
In-Reply-To: <1265249510-3205-1-git-send-email-ngupta@vflare.org>
References: <1265249510-3205-1-git-send-email-ngupta@vflare.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Feb 2010 07:41:50 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> Update email address for Nitin Gupta (myself)
> 
> ...
>
> diff --git a/lib/lzo/lzo1x_compress.c b/lib/lzo/lzo1x_compress.c
> index a604099..37c499d 100644
> --- a/lib/lzo/lzo1x_compress.c
> +++ b/lib/lzo/lzo1x_compress.c
> @@ -7,7 +7,7 @@
>   *  http://www.oberhumer.com/opensource/lzo/
>   *
>   *  Changed for kernel use by:
> - *  Nitin Gupta <nitingupta910@gmail.com>
> + *  Nitin Gupta <ngupta@vflare.org>
>   *  Richard Purdie <rpurdie@openedhand.com>
>   */
>  

It would be better to remove the email address from these files and
then add a MAINTAINERS entry.  ("All problems in computer science can
be solved by another level of indirection"!).


