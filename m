Return-Path: <linux-kernel-owner+w=401wt.eu-S965855AbXBOKuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965855AbXBOKuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965809AbXBOKuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:50:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965855AbXBOKuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:50:21 -0500
Date: Thu, 15 Feb 2007 05:50:12 -0500
From: Dave Jones <davej@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: v j <vj.linux@gmail.com>, Trent Waddington <trent.waddington@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070215105011.GA4610@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeff Garzik <jeff@garzik.org>, v j <vj.linux@gmail.com>,
	Trent Waddington <trent.waddington@gmail.com>,
	linux-kernel@vger.kernel.org
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <3d57814d0702142147p4eede234ybc9880a38772f55f@mail.gmail.com> <9b3a62ab0702142214p5c33a02am7e783c59ae0a64f1@mail.gmail.com> <3d57814d0702142235i687f8481x4eb72269e7f7fa9b@mail.gmail.com> <9b3a62ab0702142246r7e4eac4bv26c2ed46ff588871@mail.gmail.com> <20070215073238.GC917@redhat.com> <45D42B93.3060209@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D42B93.3060209@garzik.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 04:44:51AM -0500, Jeff Garzik wrote:
 > Dave Jones wrote:
 > > On Wed, Feb 14, 2007 at 10:46:13PM -0800, v j wrote:
 > >  > Using our source code would not benefit anybody but
 > >  > our competitors.
 > > 
 > > This excuse has been given time and time again, and repeatedly been 
 > > proven false.  And as soon as one of your competitors makes their
 > > drivers open, guess which one gets 1000+ free developers working
 > > on their code ?
 > 
 > 
 > Customers also like to buy hardware where they -know- support will not 
 > disappear in a year, when the vendor releases a new chip.

Absolutely. This is a very good point.
And users of binary blobs like nvidia.ko are already beginning to see
this problem.   (Nvidia dropped support for "legacy" cards a while back)

Only open drivers ensure ongoing vendor-independant support, which
is an important thing.   I'd not be happy buying a device that I know
the vendor is going to ship security updates for a year after release.
VJ, how long does your company support each product? And how much
engineering effort is spent doing so, vs effort that you could get
for free by opening your driver(s) ?

 > In fact, in some markets, the engineers who wrote the code have often 
 > moved to the next project, by the time the customers actually get their 
 > hands on the end result.  Open source means that problems found in real 
 > world field testing can be readily debugged and fixed.

Even open drivers have the same problem.  Take for example longhaul.c.
I lost interest in this a while ago and moved on to shinier new hardware
(whilst it still had numerous problems) and rafal picked this up and has
been fixing it up like something possessed since.
If this were a closed driver, it would have been doomed never to improve.

It's a great example of one of the strengths of the open process.

		Dave

-- 
http://www.codemonkey.org.uk
