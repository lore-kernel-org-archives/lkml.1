Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZFPAla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZFPAla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 20:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZFPAlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 20:41:18 -0400
Received: from mail.atheros.com ([12.36.123.2]:38755 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZFPAlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 20:41:17 -0400
Date: Mon, 15 Jun 2009 17:41:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Greg KH <greg@kroah.com>, <corbet@lwn.net>
CC: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>
Subject: Re: [RFC] Documentation: add documentation for rc-series and merge
	window
Message-ID: <20090616004122.GC5492@tesla>
References: <1245096771-3966-1-git-send-email-lrodriguez@atheros.com> <20090615201934.GA12685@kroah.com> <20090615214735.GE23972@bombadil.infradead.org> <20090615223206.GA4966@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090615223206.GA4966@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 03:32:06PM -0700, Greg KH wrote:
> On Mon, Jun 15, 2009 at 05:47:35PM -0400, Luis R. Rodriguez wrote:
> > From: Luis R. Rodriguez <lrodriguez@atheros.com>
> > Subject: [PATCH] Documentation: add documentation summary for rc-series and merge window
> >
> > This is losely based on previous discussions on linux-kernel [1][2].
> > Lets also refer people reading the stable rules to
> > Documentation/development-process/.
> >
> > [1] http://marc.info/?l=linux-kernel&m=122048427801324&w=2
> > [2] http://marc.info/?l=linux-netdev&m=122048757705315&w=2
> >
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  Documentation/development-process/2.Process |   66 +++++++++++++++++++++++++++
> >  Documentation/stable_kernel_rules.txt       |    5 ++
> >  2 files changed, 71 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
> > index d750321..e023db6 100644
> > --- a/Documentation/development-process/2.Process
> > +++ b/Documentation/development-process/2.Process
> 
> You should cc: the author of this document, when modifying it.

Added.

> > @@ -7,6 +7,72 @@ course of one year, the kernel has since had to evolve a number of
> >  processes to keep development happening smoothly.  A solid understanding of
> >  how the process works is required in order to be an effective part of it.
> >
> > +2.0 SUMMARY
> > +
> > +This section provides a brief summary of the new kernel release rules.
> > +
> > +2.0.0 NEW KERNEL RELEASE RULES
> 
> "New"?  We've been doing this for many many years now, what is "new"
> about it?

New as in the next kernel release, sorry. Didn't mean as in "this is a
new process".

> And why are you starting a series with "0"?  Just to keep from having to
> modify all of the other numbers?  None of the other files in this
> directory start at 0...

Heh yeah.

  Luis
