Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbXD1Gpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbXD1Gpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXD1Gpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:45:43 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:41363 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbXD1Gpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:45:42 -0400
X-IronPort-AV: i="4.14,464,1170651600"; 
   d="scan'208"; a="36739607:sNHT22450036"
Subject: Re: [patch 00/33] 2.6.20-stable review
From: Bryan WU <bryan.wu@analog.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20070428054800.GA6267@suse.de>
References: <20070426165445.GA1898@kroah.com>
	 <1177668954.5969.18.camel@roc-desktop> <20070427151314.GA10281@suse.de>
	 <1177734084.9029.10.camel@roc-desktop>  <20070428054800.GA6267@suse.de>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 14:46:16 +0800
Message-Id: <1177742776.9029.17.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 22:48 -0700, Greg KH wrote:
> On Sat, Apr 28, 2007 at 12:21:24PM +0800, Bryan WU wrote:
> > On Fri, 2007-04-27 at 08:13 -0700, Greg KH wrote:
> > > On Fri, Apr 27, 2007 at 06:15:54PM +0800, Wu, Bryan wrote:
> > > > 
> > > > You know for some customer's product, they want to use the stable and
> > > > long term support kernel instead to use the latest one. 
> > > 
> > > Then they should get that support from a vendor, not from the kernel.org
> > > releases :)
> > > 
> > 
> > Yeah, but we are the vendor as you mentioned. -:))
> 
> Ah, then you already know what to do :)
> 
> > If we wanna to release a kernel to customer product development, how to
> > choose the stable version?
> 
> That's up to you.
> 
> > Currently, we always followed the kernel release cycle/rules and give
> > customer the latest stable version.
> 
> Ok, then what has really changed here?  We've been doing this .y release
> thing (also called -stable) for about 2 years now, nothing is different
> this week from last.
> 
> Confused,

It's clear to me. Thanks.

You know, because the kernel development is so active and so many stable
versions release, it is very hard to decide use which version for mass
production, especially some embedded systems which does not often
upgrade. 

I know it is an old topic, sorry for confusing.
Thanks
-Bryan
