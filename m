Return-Path: <linux-kernel-owner+w=401wt.eu-S934201AbXLRHI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201AbXLRHI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760757AbXLRHIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:08:50 -0500
Received: from colo.lackof.org ([198.49.126.79]:58496 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760465AbXLRHIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:08:48 -0500
Date: Tue, 18 Dec 2007 00:08:25 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] drivers/parisc/: Spelling fixes
Message-ID: <20071218070825.GC6570@colo.lackof.org>
References: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918892.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918892.git.joe@perches.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,
ditto - thanks

On Mon, Dec 17, 2007 at 11:40:10AM -0800, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

thanks again,
grant

> ---
>  drivers/parisc/ccio-dma.c |    4 ++--
>  drivers/parisc/hppb.c     |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
> index 7c60cbd..ca52307 100644
> --- a/drivers/parisc/ccio-dma.c
> +++ b/drivers/parisc/ccio-dma.c
> @@ -363,7 +363,7 @@ ccio_alloc_range(struct ioc *ioc, size_t size)
>  	if (pages_needed <= 8) {
>  		/*
>  		 * LAN traffic will not thrash the TLB IFF the same NIC
> -		 * uses 8 adjacent pages to map seperate payload data.
> +		 * uses 8 adjacent pages to map separate payload data.
>  		 * ie the same byte in the resource bit map.
>  		 */
>  #if 0
> @@ -1589,7 +1589,7 @@ static int __init ccio_probe(struct parisc_device *dev)
>  }
>  
>  /**
> - * ccio_init - ccio initalization procedure.
> + * ccio_init - ccio initialization procedure.
>   *
>   * Register this driver.
>   */
> diff --git a/drivers/parisc/hppb.c b/drivers/parisc/hppb.c
> index a728a7c..65eee67 100644
> --- a/drivers/parisc/hppb.c
> +++ b/drivers/parisc/hppb.c
> @@ -95,7 +95,7 @@ static struct parisc_driver hppb_driver = {
>  };
>  
>  /**
> - * hppb_init - HP-PB bus initalization procedure.
> + * hppb_init - HP-PB bus initialization procedure.
>   *
>   * Register this driver.   
>   */
> -- 
> 1.5.3.7.949.g2221a6
