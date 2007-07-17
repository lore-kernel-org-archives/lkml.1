Return-Path: <linux-kernel-owner+w=401wt.eu-S932884AbXGQBHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbXGQBHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139AbXGQBHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:07:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38730 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbXGQBHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:07:19 -0400
Message-ID: <469C163E.40905@garzik.org>
Date: Mon, 16 Jul 2007 21:07:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Linus Torvalds <torvalds@linux-foundation.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>, netdev@vger.kernel.org
Subject: Re: [patch 37/44] xen: add virtual network device driver
References: <20070716231536.937393000@xensource.com>> <20070716232916.472694000@xensource.com>>
In-Reply-To: <20070716232916.472694000@xensource.com>>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> The network device frontend driver allows the kernel to access network
> devices exported exported by a virtual machine containing a physical
> network device driver.
> 
> 
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> Cc: Ian Pratt <ian.pratt@xensource.com>
> Cc: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: Stephen Hemminger <shemminger@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
> Cc: netdev@vger.kernel.org

Seems fairly reasonable.  ACK, presuming Xen dependencies are also merged.

	Jeff



