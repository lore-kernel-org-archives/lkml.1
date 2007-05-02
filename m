Return-Path: <linux-kernel-owner+w=401wt.eu-S2992800AbXEBGrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992800AbXEBGrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992826AbXEBGrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:47:41 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:43076 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992859AbXEBGrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:47:40 -0400
Date: Tue, 1 May 2007 23:45:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, ak@suse.de,
       akpm@linux-foundation.org, virtualization@lists.osdl.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [patch 31/32] xen: --- drivers/net/xen-netfront.c | 6 +++--- 1 file changed, 3 insertions(+), 3 deletions(-)
Message-ID: <20070502064553.GA2819@sequoia.sous-sol.org>
References: <20070429172916.861677000@goop.org> <E1Hj8PR-0007wA-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hj8PR-0007wA-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Herbert Xu (herbert@gondor.apana.org.au) wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > ===================================================================
> > --- a/drivers/net/xen-netfront.c
> > +++ b/drivers/net/xen-netfront.c
> > @@ -1213,10 +1213,10 @@ static int netif_poll(struct net_device 
> 
> Any reason why xen-netfront isn't just in a single patch? It makes
> it a bit hard to review having it scattered around like this.

It simply maps directly to the patch queue.  We do go back and fold
things in and that should probably be done again, I agree.

thanks,
-chris
