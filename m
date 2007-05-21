Return-Path: <linux-kernel-owner+w=401wt.eu-S1763338AbXEURLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763338AbXEURLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756380AbXEURLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:11:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365AbXEURLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:11:15 -0400
Date: Mon, 21 May 2007 13:11:09 -0400
From: Dave Jones <davej@redhat.com>
To: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
Subject: Re: RFC: Schedule EFS for removal.
Message-ID: <20070521171109.GC9653@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
References: <20070521144618.GA6914@redhat.com> <20070521150242.GA25146@infradead.org> <20070521150937.GB6957@redhat.com> <20070521151209.GA25744@infradead.org> <20070521152050.GC6957@redhat.com> <20070521154613.GA27027@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521154613.GA27027@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 04:46:13PM +0100, Christoph Hellwig wrote:
 > On Mon, May 21, 2007 at 11:20:50AM -0400, Dave Jones wrote:
 > > On Mon, May 21, 2007 at 04:12:09PM +0100, Christoph Hellwig wrote:
 > >  > > Ok, patch rescinded.  Any opinion on what to do about that bug?
 > >  > > 
 > >  > > "use loopback" would be one option I guess.
 > >  > > Given its been an open bug for four years, there's obviously
 > >  > > not that much interest in fixing the filesystem.
 > >  > 
 > >  > I don't think it's a bug, it's a lacking feature.  The error message
 > >  > is quite accurate aswell.
 > > 
 > > It seems to be a regression in 2.6.x though.  From the report..
 > > 
 > > "Under 2.4.21, it doesnt do this."
 > 
 > Randy mentioned in bugzilla that 2.4.22 didn't work either, so I'd
 > be very surprised if 2.4.21 works.

good point.  I don't see anything obvious in 2.4.22 that would have
caused a regression, so this sounds suspect.
I'll close the bugzilla out based on your comments, thanks for looking at it.

	Dave

-- 
http://www.codemonkey.org.uk
