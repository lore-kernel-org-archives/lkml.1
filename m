Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXJHAoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXJHAoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 20:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXJHAoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 20:44:03 -0400
Received: from koto.vergenet.net ([210.128.90.7]:52978 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXJHAoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 20:44:01 -0400
Date: Mon, 8 Oct 2007 10:43:37 +1000
From: Simon Horman <horms@verge.net.au>
To: joe@perches.com
Cc: wensong@linux-vs.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ja@ssi.bg,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [343/2many] MAINTAINERS - IPVS
Message-ID: <20071008004333.GF2497@verge.net.au>
References: <46bffb10.JY5EkYQg+QBB0ZZx%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffb10.JY5EkYQg+QBB0ZZx%joe@perches.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:32:48PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dbfdb75..a8fb231 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3300,6 +3300,8 @@ P:	Julian Anastasov
>  M:	ja@ssi.bg
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/networking/ipvs-sysctl.txt
> +F:	net/ipv4/ipvs

Should the following also be added:?

+F: include/net/ip_vs.h

>  
>  NFS CLIENT
>  P:	Trond Myklebust
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

