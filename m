Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbZGICZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbZGICZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbZGICZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:25:35 -0400
Received: from xenotime.net ([72.52.64.118]:45708 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756418AbZGICZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:25:35 -0400
Message-ID: <4A555525.3080006@xenotime.net>
Date: Wed, 08 Jul 2009 19:25:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/7] MAINTAINERS: Update KERNEL JANITORS
References: <cover.1247032324.git.joe@perches.com> <5bb2fa279bcbf854b056b8df8ff4b9f675613b72.1247032324.git.joe@perches.com>
In-Reply-To: <5bb2fa279bcbf854b056b8df8ff4b9f675613b72.1247032324.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ef07f59..73b4b02 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3366,10 +3366,9 @@ F:	Makefile
>  F:	scripts/Makefile.*
>  
>  KERNEL JANITORS
> -P:	Several
>  L:	kernel-janitors@vger.kernel.org
> -W:	http://www.kerneljanitors.org/
> -S:	Maintained
> +W:	http://janitor.kernelnewbies.org/
> +S:	Odd fixes
>  
>  KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
>  P:	J. Bruce Fields

Alexey could comment on that, but I agree with it.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

