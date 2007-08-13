Return-Path: <linux-kernel-owner+w=401wt.eu-S973554AbXHMQxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973554AbXHMQxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S948288AbXHMQ0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:26:40 -0400
Received: from pat.uio.no ([129.240.10.15]:58477 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S948244AbXHMQ0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:26:35 -0400
Subject: Re: [PATCH] [344/2many] MAINTAINERS - NFS CLIENT
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46bffb13.g6PWKhDCxXTpAZFm%joe@perches.com>
References: <46bffb13.g6PWKhDCxXTpAZFm%joe@perches.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 12:26:27 -0400
Message-Id: <1187022387.6628.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.074)
X-UiO-Scanned: 9B222AF606B0E07F3C4BDBB9E5C1A544F7F2AB2B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 281 total 3223828 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-12 at 23:32 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a8fb231..1f81c05 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3308,6 +3308,12 @@ P:	Trond Myklebust
>  M:	trond.myklebust@fys.uio.no
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> +F:	fs/nfs/
> +F:	fs/nfs_common/
> +F:	fs/nfsctl.c
> +F:	fs/nfsd/
> +F:	include/linux/nfs*
> +F:	include/linux/nfsd/
>  
>  NI5010 NETWORK DRIVER
>  P:	Jan-Pascal van Best

I'm not planning on taking over the maintainership of nfsd or
fs/nfsctl.c anytime soon.

However fs/lockd, include/linux/lockd/ is missing, as is
include/linux/sunrpc and net/sunrpc/

Trond

