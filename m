Return-Path: <linux-kernel-owner+w=401wt.eu-S973288AbXHMQjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973288AbXHMQjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968329AbXHMPqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:46:10 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56725 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968259AbXHMPpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:45:50 -0400
Date: Mon, 13 Aug 2007 10:45:48 -0500
To: joe@perches.com
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [459/2many] MAINTAINERS - SPIDERNET NETWORK DRIVER for CELL
Message-ID: <20070813154548.GA4338@austin.ibm.com>
References: <46bffbfa.6q67BtSh8n+UV4q4%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffbfa.6q67BtSh8n+UV4q4%joe@perches.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:36:42PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b616562..fa8fb1c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4377,6 +4377,9 @@ P:	Linas Vepstas
>  M:	linas@austin.ibm.com
>  L:	netdev@vger.kernel.org
>  S:	Supported
> +F:	Documentation/networking/spider_net.txt
> +F:	arch/powerpc/platforms/cell/spider-pic.c
> +F:	drivers/net/spider_net*

Note quite right. spider-pic is not part of spider_net.
The rest loks fine.

--linas

