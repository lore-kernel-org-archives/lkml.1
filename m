Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZHBX5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZHBX5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 19:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZHBX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 19:57:23 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46736 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbZHBX5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 19:57:22 -0400
Date: Mon, 3 Aug 2009 09:57:22 +1000
From: Simon Horman <horms@verge.net.au>
To: Hannes Eder <heder@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add IPVS include files
Message-ID: <20090802235722.GM6177@verge.net.au>
References: <20090802124843.5339.86283.stgit@jazzy.zrh.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802124843.5339.86283.stgit@jazzy.zrh.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 02:49:47PM +0200, Hannes Eder wrote:
> Signed-off-by: Hannes Eder <heder@google.com>
Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  MAINTAINERS |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a50aa7f..4175d73 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2791,6 +2791,8 @@ L:	netdev@vger.kernel.org
>  L:	lvs-devel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/networking/ipvs-sysctl.txt
> +F:	include/net/ip_vs.h
> +F:	include/linux/ip_vs.h
>  F:	net/netfilter/ipvs/
>  
>  IPWIRELESS DRIVER
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
