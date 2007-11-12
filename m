Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbXKLH7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbXKLH7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 02:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbXKLH7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 02:59:01 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33149 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751277AbXKLH7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 02:59:00 -0500
Date: Mon, 12 Nov 2007 08:58:36 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Simon Horman <horms@verge.net.au>
Cc: "Rumen G. Bogdanovski" <rumen@voicecho.com>, wensong@linux-vs.org,
       ja@ssi.bg, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       LVS Development mailing list 
	<lvs-devel@linuxvirtualserver.org>
Subject: Re: [2.6 patch] net/ipv4/ipvs/: remove unused exports
Message-ID: <20071112075836.GE9771@stusta.de>
References: <20071111064840.GJ21669@stusta.de> <20071111070939.GA25304@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071111070939.GA25304@verge.net.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 04:09:40PM +0900, Simon Horman wrote:
> On Sun, Nov 11, 2007 at 07:48:40AM +0100, Adrian Bunk wrote:
> > This patch removes the following unused EXPORT_SYMBOL's:
> > - ip_vs_try_bind_dest
> > - ip_vs_find_dest
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Looks fine to me.
> 
> Should Dave Miller put this in his tree,
> or do you want to handle it a different way?
>...

If Dave applies it that would be perfect.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

