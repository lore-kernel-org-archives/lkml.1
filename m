Return-Path: <linux-kernel-owner+w=401wt.eu-S1764967AbYBLVBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764967AbYBLVBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762847AbYBLVAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:00:51 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33710 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760092AbYBLVAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:00:49 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802122116400.7699@twin.jikos.cz>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	 <20080212044314.GA4888@kroah.com>
	 <20080211211751.3e265754@laptopd505.fenrus.org>
	 <20080211.221126.230471463.davem@davemloft.net>
	 <47B1CB08.4020101@garzik.org>
	 <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	 <1202838082.3137.54.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
	 <1202840682.3137.83.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802122116400.7699@twin.jikos.cz>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 15:00:43 -0600
Message-Id: <1202850043.3137.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 21:18 +0100, Jiri Kosina wrote:
> On Tue, 12 Feb 2008, James Bottomley wrote:
> 
> > >  Rebases *do*not*work* (and fundamentally cannot work) in a 
> > > distributed environment.
> > Hm ... I think net is a counter example to this.  Rebases certainly work
> > for them.  The issue, I thought, was around the policy of rebasing and
> > how often.
> 
> Hmm ... as far as I can see, Jeff and John (i.e. net tree downstreams) are 
> pretty loudly unhappy with Dave rebasing too often, right?

That's true ... but irrelevant to the argument of whether rebasing does
or doesn't work.  I don't think anyone's arguing that rebasing doesn't
cause real problems to downstream users ... when I was based on block
for the scsi post merge tree, I was just such a user ...

James


