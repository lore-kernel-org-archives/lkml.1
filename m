Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbYCYSbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbYCYSbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbYCYSbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:31:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:44718 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757359AbYCYSbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:31:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19I5QdacO9I9bWe47Ogd/ShOMi7kBsaB2zun5t3n6
	AD4ZPaRoDqsZoj
Subject: Re: Scalability requirements for sysv ipc
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1206461630.8514.441.camel@twins>
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>
	 <47E3B924.3000304@colorfullife.com>
	 <20080321141339.GB9618@linux.vnet.ibm.com>
	 <47E3DD8C.4000904@colorfullife.com>
	 <1206164608.3659.11.camel@marge.simson.net>
	 <47E4DB06.3020003@colorfullife.com>
	 <1206186832.4545.1.camel@marge.simson.net>
	 <47E51637.8060102@colorfullife.com>  <47E55945.10109@colorfullife.com>
	 <1206460206.4414.21.camel@marge.simson.net>
	 <1206461630.8514.441.camel@twins>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 19:31:03 +0100
Message-Id: <1206469863.4622.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-25 at 17:13 +0100, Peter Zijlstra wrote:
> On Tue, 2008-03-25 at 16:50 +0100, Mike Galbraith wrote:

> > ...and I verified it via :-/ echo 7 > sched_features in latest.  That
> > only bought me roughly half though, so there's a part three in there
> > somewhere.
> 
> Ouch, I guess hrtimers are just way expensive on some hardware... 

That would be about on par with my luck.  I'll try to muster up the
gumption to go looking for part three, though my motivation for
searching long ago proved to be a dead end wrt sysv ipc.

	-Mike

