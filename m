Return-Path: <linux-kernel-owner+w=401wt.eu-S1763667AbXEURUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763667AbXEURUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbXEURT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:19:56 -0400
Received: from xenotime.net ([66.160.160.81]:58802 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755902AbXEURTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:19:55 -0400
Date: Mon, 21 May 2007 10:25:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       rdunlap@xenotime.net
Subject: Re: RFC: Schedule EFS for removal.
Message-Id: <20070521102549.a93690bb.rdunlap@xenotime.net>
In-Reply-To: <20070521171242.GA30854@infradead.org>
References: <20070521144618.GA6914@redhat.com>
	<20070521150242.GA25146@infradead.org>
	<20070521150937.GB6957@redhat.com>
	<20070521151209.GA25744@infradead.org>
	<20070521152050.GC6957@redhat.com>
	<20070521154613.GA27027@infradead.org>
	<20070521171109.GC9653@redhat.com>
	<20070521171242.GA30854@infradead.org>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 18:12:42 +0100 Christoph Hellwig wrote:

> On Mon, May 21, 2007 at 01:11:09PM -0400, Dave Jones wrote:
> >  > Randy mentioned in bugzilla that 2.4.22 didn't work either, so I'd
> >  > be very surprised if 2.4.21 works.
> > 
> > good point.  I don't see anything obvious in 2.4.22 that would have
> > caused a regression, so this sounds suspect.
> > I'll close the bugzilla out based on your comments, thanks for looking at it.
> 
> Btw, I'd like to take a look at Randy's patches for bigger block sizes,
> it might be quite easy to fix the remaining bits.  Does anyone have
> a copy since the link doesn't work anymore?

Sorry about that.  The patches are back in this dir:
  http://www.xenotime.net/linux/efs/

but I don't recall much about them.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
