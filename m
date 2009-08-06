Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZHFQnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZHFQnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:43:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZHFQnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:43:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40737 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZHFQnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:43:00 -0400
Date: Thu, 6 Aug 2009 17:40:01 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Pavel Machek <pavel@ucw.cz>,
       Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
	sections
Message-ID: <20090806164001.GA31507@flint.arm.linux.org.uk>
References: <20090806125751.7d0253ce@nij0285> <20090806113104.GK31370@elf.ucw.cz> <20090806120826.GC27773@flint.arm.linux.org.uk> <4A7ACC8D.7030706@xenontk.org> <20090806124048.GD27773@flint.arm.linux.org.uk> <1249563730.10297.13.camel@Joe-Laptop.home> <20090806133349.GF27773@flint.arm.linux.org.uk> <1249568614.10297.20.camel@Joe-Laptop.home> <20090806150322.GX2080@trinity.fluff.org> <1249575528.3467.9.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249575528.3467.9.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 09:18:48AM -0700, Joe Perches wrote:
> On Thu, 2009-08-06 at 16:03 +0100, Ben Dooks wrote:
> > On Thu, Aug 06, 2009 at 07:23:34AM -0700, Joe Perches wrote:
> > > On Thu, 2009-08-06 at 14:33 +0100, Russell King wrote:
> > > > On Thu, Aug 06, 2009 at 06:02:10AM -0700, Joe Perches wrote:
> > > > > I suspect a vger based ARM list would not require you to "run" it.
> > > > There is already a vger based ARM list.  I see no signs of people
> > > > moving over to it.  I summise that is because most people don't
> > > > have a problem, and most people are happy with the existing lists
> > > > as they stand.  Could it be that it's only a minority who are
> > > > having issues.  I don't know.
> > > 
> > > Perhaps there is too little exposure of the
> > > linux-arm@vger.kernel.org mailing list.
> > 
> > I'm not subscribed, please do not add any of the samsung entries
> > with linux-arm@vger.kernel.org list.
> 
> Perhaps this patch is more palatable.  It's certainly shorter.
> 
> It does add both linux-arm-kernel and linux-arm to section
> SIMTEC EB2410ITX (BAST).  By the way, another section you
> maintain, SIMTEC EB110ATX (Chalice CATS), has neither a
> pattern entry nor a mailing list entry.  Should it?

I recently had to remove those pattern entries because they were plainly
wrong (thanks to those who didn't CC anyone in the ARM community with
those patches.)  EB110ATX != EBSA110.  See ce53895.

I had asked the maintainer of that platform to submit a patch to add the
correct entries.  Rather than having plainly bogus entries in there,
let's have either nothing or the right entries.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
