Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbXEJWxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbXEJWxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbXEJWxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:53:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49038
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbXEJWxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:53:22 -0400
Date: Thu, 10 May 2007 15:53:24 -0700 (PDT)
Message-Id: <20070510.155324.111718436.davem@davemloft.net>
To: jeremy@goop.org
Cc: akpm@linux-foundation.org, herbert@gondor.apana.org.au, hch@infradead.org,
       ak@suse.de, virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, ian.pratt@xensource.com,
       Christian.Limpach@cl.cam.ac.uk, netdev@vger.kernel.org, jeff@garzik.org,
       shemminger@linux-foundation.org, rusty@rustcorp.com.au,
       Valdis.Kletnieks@vt.edu
Subject: Re: [1/2] [NET] link_watch: Move link watch list into net_device
From: David Miller <davem@davemloft.net>
In-Reply-To: <4643A096.7000909@goop.org>
References: <46439B19.7010706@goop.org>
	<20070510.152552.117703057.davem@davemloft.net>
	<4643A096.7000909@goop.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Thu, 10 May 2007 15:45:42 -0700

> David Miller wrote:
> > I'm not so certain now that we know it's the jiffies wrap point :-)
> >
> > The fixes in question are attached below and they were posted and
> > discussed on netdev:
> >   
> 
> Yep, this patch gets rid of my spinning thread.  I can't find this patch
> or any discussion on marc.info; is there a better netdev list archive?

I don't see it there either... let me check my mail archive...

Indeed, they were "posted" to netdev but were blocked by the vger
regexp filters on the keyword "urgent" so that postings never made it
to the list.  I removed that filter regexp so that never happens
again, sorry.
