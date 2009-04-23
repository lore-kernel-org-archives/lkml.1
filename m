Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbZDWPs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbZDWPs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZDWPsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:48:16 -0400
Received: from kroah.org ([198.145.64.141]:34297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZDWPsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:48:15 -0400
Date: Thu, 23 Apr 2009 08:45:02 -0700
From: Greg KH <greg@kroah.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "stable@kernel.org" <stable@kernel.org>, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Jake Edge <jake@lwn.net>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [stable] [patch 000/100] 2.6.29.2 -stable review
Message-ID: <20090423154502.GA27609@kroah.com>
References: <20090423072020.428683652@sous-sol.org> <200904231556.38723.tvrtko.ursulin@sophos.com> <20090423150200.GA26871@kroah.com> <200904231608.42147.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904231608.42147.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:08:41PM +0100, Tvrtko Ursulin wrote:
> On Thursday 23 April 2009 16:02:00 Greg KH wrote:
> [snip]
> > > > > Hi,
> > > > >
> > > > > Could you please include a fix for forcedeth resume from hibernation
> > > > > regression as well?
> > > > >
> > > > > http://marc.info/?l=linux-netdev&m=123885046818928&w=4
> > > >
> > > > Do you have the git commit id of this patch in Linus's tree?
> > >
> > > It should be this one 35a7433c789ba6df6d96b70fa745ae9e6cac0038.
> >
> > Looks good, we should queue it up for the next release (at 100 patches,
> > this one looks pretty full...)
> 
> OK, but if at all possible please squeeze it in in .2. I copied stable twice I 
> think during the discussion about this regression which was almost one month 
> ago now.

Yes, but you never provided the git commit id of the patch that is in
Linus's tree to us.  Without that, knowing what to add to the -stable
tree is pretty much impossible, given our current workload of the
-stable queue.

Please make it very easy on us, we are slow :)

thanks,

greg k-h
