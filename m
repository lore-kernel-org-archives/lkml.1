Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbZJ1BGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbZJ1BGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 21:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbZJ1BGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 21:06:49 -0400
Received: from kroah.org ([198.145.64.141]:38976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006AbZJ1BGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 21:06:48 -0400
Date: Tue, 27 Oct 2009 18:05:35 -0700
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [quilt patches] Staging: rt28x0: more cleanups
Message-ID: <20091028010535.GA14956@kroah.com>
References: <200910252134.17360.bzolnier@gmail.com> <20091027174728.GE23368@kroah.com> <200910271924.40420.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910271924.40420.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 07:24:40PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 27 October 2009 18:47:28 Greg KH wrote:
> > On Sun, Oct 25, 2009 at 09:34:17PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > Hi,
> > > 
> > > More cleanups:
> > > - run all files through scripts/Lindent
> > > - convert C++ style comments to C style
> > > - remove typedefs
> > > 
> > > As a result those drivers start looking Linux-like and become easier
> > > to comprehend, also as an added bonus another 1.5 KLOC are gone..
> > > 
> > > The downside is that it will be harder now to port over updates from
> > > the original vendor source code than it was in the past..
> > > 
> > > As usual all changes were tested with RT2860 and RT3070.
> > > 
> > > 
> > > Cause patches are too big for a mailing list they are available at:
> > > 
> > > http://www.kernel.org/pub/linux/kernel/people/bart/staging-rt28x0-more-cleanups/
> > 
> > Does this series have your 00/12 set in them as well?
> 
> Nope, this one is on top of 00/12 set.

Ok, I'll queue that one up first, thanks.

greg k-h
