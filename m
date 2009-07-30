Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZG3KFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZG3KFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZG3KFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:05:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:41962 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752623AbZG3KFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:05:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+NRs8vZwGNeuVHJfPS+q76STose72iYwTkDevJAl
	b/REnOOTpWgN2u
Subject: Re: [wireless] rt2870sta BUGs on shutdown,
 2.6.30.2->git.today+git.wireless.today
From: Mike Galbraith <efault@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1248947740.8925.12.camel@johannes.local>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 12:05:26 +0200
Message-Id: <1248948326.8823.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 11:55 +0200, Johannes Berg wrote:
> On Thu, 2009-07-30 at 11:44 +0200, Mike Galbraith wrote:
> > On Thu, 2009-07-30 at 11:29 +0200, Johannes Berg wrote:
> > > On Thu, 2009-07-30 at 11:22 +0200, Mike Galbraith wrote:
> > > 
> > > > drivers/staging/rt2870/../rt2860/sta_ioctl.c
> > > 
> > > Sorry, but that '/staging/' thing in there means we cannot support this.
> > > If you must, take your query to the staging list,
> > > devel@driverdev.osuosl.org (according to MAINTAINERS).
> > 
> > Forwarded, thanks.
> > 
> > ....hm.  Does "If you must" mean reports aren't welcome?
> 
> To be honest, I don't know. I'd rather see people use the rt2x00 code
> instead of spending time cleaning up that mess (the code you've pasted
> was pretty bad!). But you may or may not find somebody who cares about
> that, just rather unlikely on this list.

Understood (and yeah, the source is.. not pretty).  Sorry for the noise.

WRT rt2x00 with this adapter, I tried it, was a nogo.  If I find time,
I'll reconfigure/report.

	-Mike (outta here;)

