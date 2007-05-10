Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbXEJNjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbXEJNjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760200AbXEJNjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:39:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50506 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759586AbXEJNjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:39:18 -0400
Date: Thu, 10 May 2007 14:43:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/10] Linux Kernel Markers - Documentation
Message-ID: <20070510144302.6a7826d6@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0705101606130.22625@sbz-30.cs.Helsinki.FI>
References: <20070510015555.973107048@polymtl.ca>
	<20070510020917.172554217@polymtl.ca>
	<20070510065847.GE8019@infradead.org>
	<20070510124120.6e8ac5aa@the-village.bc.nu>
	<20070510114158.GA16741@infradead.org>
	<20070510134816.5e57e3cb@the-village.bc.nu>
	<84144f020705100552u3f988e80u29fc412737522259@mail.gmail.com>
	<20070510140452.25ae6765@the-village.bc.nu>
	<Pine.LNX.4.64.0705101606130.22625@sbz-30.cs.Helsinki.FI>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> Oh, I am not advocating censorship. I was merely pointing out that it 
> seems silly to mention out-of-tree users because they come and go. Who 
> knows whether LTTng or SystemTAP will be relevant five years from now? 

And in the intervening five years (or more likely 7 or more for
systemtap) the documentation will be very useful.

> Besides, are we sure the document includes all potential users now? We 
> wouldn't want to show favorism to any particular projects, now would we?

Absolutely not - and isn't it more useful to let users know about all of
the tools that this enables ?

> 
> On Thu, 10 May 2007, Alan Cox wrote: 
> > And as I keep saying the tree is full of references to out of tree stuff.
> > The documentation directory alone currently contains over a thousand http
> > URLS as of 2.6.21-rc6-mm1.
> 
> Many of the already out of date or expiring in the near future... 

Have you done a statistically valid sampling or is this guessing ?

Alan
