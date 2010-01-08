Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774Ab0AHKX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab0AHKX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 05:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144Ab0AHKX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 05:23:56 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:45287 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0AHKXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 05:23:55 -0500
Date: Fri, 8 Jan 2010 05:23:13 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Greg KH <greg@kroah.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Documentation/feature-removal-schedule.txt to be updated soon?
In-Reply-To: <20100103212913.GB3220@kroah.com>
Message-ID: <alpine.LFD.2.00.1001080515560.11113@localhost>
References: <alpine.LFD.2.00.1001030652110.6587@localhost> <20100103212913.GB3220@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jan 2010, Greg KH wrote:

> On Sun, Jan 03, 2010 at 06:54:10AM -0500, Robert P. J. Day wrote:
> >
> >   as is my wont, i will mutter quietly about the amount of content
> > in the file Documentation/feature-removal-schedule.txt referring
> > to stuff that should have been removed ages ago (some of it is
> > dated as far back as 2005).
> >
> >   is there any plan on bringing that file up to date, and/or
> > deleting stuff that's been marked for deletion for years?
>
> Sure, feel free to send patches, and if they are rejected, send a
> patch for the feature-removal-schedule.txt file removing the option
> there.

  that's a nice idea, i wonder how well it would work in practice.  a
couple years ago, i submitted a patch to remove the *clearly*
deprecated/obsolete pcmcia ioctl feature.  that was less than
spectacularly successful:

http://lists.infradead.org/pipermail/linux-pcmcia/2007-May/thread.html#4536

it's now 2.5 years later, that feature is still there and is now 5
years overdue for removal.  i'll submit another patch to get rid of
it, but if there's yet another argument for why it can't quite be
deleted yet, i'm not sure what value the feature-removal-schedule file
has anymore.

either people should take it moderately seriously, or it should be
deleted as a waste of time.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
