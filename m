Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbYBLUUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbYBLUUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYBLUUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:20:22 -0500
Received: from twin.jikos.cz ([213.151.79.26]:35774 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYBLUUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:20:20 -0500
Date: Tue, 12 Feb 2008 21:18:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <1202840682.3137.83.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0802122116400.7699@twin.jikos.cz>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> 
 <20080212044314.GA4888@kroah.com>  <20080211211751.3e265754@laptopd505.fenrus.org>
  <20080211.221126.230471463.davem@davemloft.net>  <47B1CB08.4020101@garzik.org>
  <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> 
 <1202838082.3137.54.camel@localhost.localdomain> 
 <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
 <1202840682.3137.83.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, James Bottomley wrote:

> >  Rebases *do*not*work* (and fundamentally cannot work) in a 
> > distributed environment.
> Hm ... I think net is a counter example to this.  Rebases certainly work
> for them.  The issue, I thought, was around the policy of rebasing and
> how often.

Hmm ... as far as I can see, Jeff and John (i.e. net tree downstreams) are 
pretty loudly unhappy with Dave rebasing too often, right?

-- 
Jiri Kosina

