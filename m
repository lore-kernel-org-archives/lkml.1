Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbZFPEjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbZFPEjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZFPEjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:39:18 -0400
Received: from mail.atheros.com ([12.36.123.2]:31907 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbZFPEjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:39:17 -0400
Date: Mon, 15 Jun 2009 21:39:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
CC: Greg KH <greg@kroah.com>, "corbet@lwn.net" <corbet@lwn.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>
Subject: Re: [RFC] Documentation: add documentation for rc-series and merge
	window
Message-ID: <20090616043922.GB5680@tesla>
References: <1245096771-3966-1-git-send-email-lrodriguez@atheros.com> <20090615201934.GA12685@kroah.com> <20090615214735.GE23972@bombadil.infradead.org> <20090615223206.GA4966@kroah.com> <20090616004122.GC5492@tesla> <20090616021011.GF23972@bombadil.infradead.org> <20090616032034.GA17932@kroah.com> <20090616042113.GA5680@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090616042113.GA5680@tesla>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 09:21:14PM -0700, Luis Rodriguez wrote:
> On Mon, Jun 15, 2009 at 08:20:34PM -0700, Greg KH wrote:
> > On Mon, Jun 15, 2009 at 10:10:11PM -0400, Luis R. Rodriguez wrote:
> > > +     2.6.30  June 10, 2009 - 79 days
> > > +     2.6.29  March 23, 2009 - 84 days
> > > +     2.6.28  December 29, 2008 - 82 days
> > > +     2.6.27  October 8, 2008 - 87 days
> > > +     2.6.26  July 13, 2008 - 88 days
> > > +     2.6.25  April 16, 2008 - 83 days
> > > +     2.6.24  January 24, 2008 - 107 days
> > > +     2.6.23  October 9, 2007 - 93 days
> > > +     2.6.22  July 8, 2007 - 74 days
> > > +     2.6.21  April 25, 2007 - 80 days
> > >       2.6.20  February 4, 2007
> >
> > Are you sure about those dates and the count of number of days?
> 
> I used this cheesy web app:
> 
> http://www.timeanddate.com/date/duration.html
> 
> So it could have told 42 for all answers I suppose and I wouldn't have known
> the difference. BTW does your list count the ending date? That is from say
> 01-01-2009 to 01-02-2009 does it count 2 or 1? I set it to not count it.
> 
> > According to my "big spreadsheet of kernel releases", your day count is
> > wrong...
> >
> > I have:
> >
> > release: v2.6.20  v2.6.21  v2.6.22  v2.6.23  v2.6.24  v2.6.25  v2.6.26  v2.6.27  v2.6.28  v2.6.29  v2.6.30
> >  date:   02/04/07 04/25/07 07/08/07 10/09/07 01/24/08 04/16/08 07/13/08 10/09/08 12/24/08 03/23/09 06/09/09
> > # Days:  68       81       75       94       108      83       88       88       76       89       78
> 
> I'll trust your big spreadsheet more and with it you actually get a nice
> even 86.0 average.

FWIW using the same cheesy web app, if we do go about the 10 kernel release
average of 86.0 days the next 2.6.31 release should be September 4, 2009.

  Luis
