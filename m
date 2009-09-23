Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZIWGnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZIWGnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZIWGnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:43:15 -0400
Received: from smtp.nokia.com ([192.100.105.134]:34756 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbZIWGnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:43:14 -0400
Subject: Re: [GIT PULL]: OMAP2/3 Display Subsystem
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Reply-To: tomi.valkeinen@nokia.com
To: ext Andrew Morton <akpm@linux-foundation.org>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>
In-Reply-To: <20090922130304.ffe24448.akpm@linux-foundation.org>
References: <1253622588.25232.11.camel@tubuntu>
	 <20090922130304.ffe24448.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Wed, 23 Sep 2009 09:42:24 +0300
Message-Id: <1253688144.14841.7.camel@tubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2009 06:42:29.0816 (UTC) FILETIME=[05887B80:01CA3C19]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 22:03 +0200, ext Andrew Morton wrote:
> On Tue, 22 Sep 2009 15:29:48 +0300
> Tomi Valkeinen <tomi.valkeinen@nokia.com> wrote:
> 
> > Linus,
> > 
> > Here's the new display subsystem and framebuffer driver for OMAP2/3.
> > 
> > The driver has been reviewed on linux-omap and linux-fbdev-devel, and is in
> > use, for example, on N900, Beagle Board and Overo boards. We have an ACK for
> > the OMAP parts from Tony Lindgren, who maintains the OMAP platform.
> > 
> > We have gotten positive feedback about the driver, for example in this thread:
> > http://marc.info/?l=linux-kernel&m=125171081901820&w=2
> > 
> > The driver is actively maintained and developed further, and I have already a
> > bunch of patches on top of these patches, but I would like to get the big core
> > driver merged first. After the driver is merged, other people can send patches
> > to LCD drivers and board files to enable the new display subsystem on their
> > boards.
> > 
> > Andrew said 2-3 weeks ago that he'll merge the driver (after he has looked
> > through it), but he hasn't responded since then. I'm guessing he's quite busy.
> 
> That's because it came very late and conflicts considerably with
> changes which are already pending.
> 
> > Please pull the new OMAP2/3 display subsystem driver from:
> > 
> >   git://gitorious.org/linux-omap-dss2/linux.git for-linus
> > 
> 
> Confused.  These conflicts heavily with the changes which I've already
> queued, does it not?  Ones which were queued way earlier than this
> material.
> 
> If so, why on earth did you send a pull request, knowing that it would
> trash my tree?

Ah, my mistake. I'm new to getting patches merged and the process
involved. Somehow I thought the patches you have went already in, and as
I didn't get any replies for couple of week, I pursued another route.
Sorry about the confusion.

Let's continue this with less audience, no need to bother everyone with
this.

 Tomi


