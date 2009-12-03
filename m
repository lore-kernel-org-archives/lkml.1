Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbZLCTcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbZLCTcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbZLCTcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:32:42 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:38223 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbZLCTcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:32:41 -0500
Date: Thu, 3 Dec 2009 11:31:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sysfs: deprecated features are to help old tools not to
 confuse them
Message-Id: <20091203113100.06b5a337.randy.dunlap@oracle.com>
In-Reply-To: <1259866680-27905-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091203083143.3a4619a4.randy.dunlap@oracle.com>
	<1259866680-27905-1-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B18121E.0025:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Dec 2009 19:58:00 +0100 Uwe Kleine-König wrote:

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Greg KH <gregkh@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.


> ---
>  init/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index eb4b337..d7ac66b 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -606,7 +606,7 @@ config SYSFS_DEPRECATED
>  	bool
>  
>  config SYSFS_DEPRECATED_V2
> -	bool "enable deprecated sysfs features which may confuse old userspace tools"
> +	bool "enable deprecated sysfs features to support old userspace tools"
>  	depends on SYSFS
>  	default n
>  	select SYSFS_DEPRECATED
> -- 


---
~Randy
