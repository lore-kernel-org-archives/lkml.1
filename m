Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbXHGGzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbXHGGzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXHGGzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:55:40 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:43937
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751384AbXHGGzk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:55:40 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Diego Calleja <diegocg@gmail.com>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Date: Mon, 6 Aug 2007 23:55:26 -0700
User-Agent: KMail/1.9.5
Cc: Bill Huey (hui) <billh@gnuppy.monkey.org>,
       jos poortvliet <jos@mijnkamer.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, ck@vds.kolivas.org,
       Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070728200705.GF32582@gnuppy.monkey.org> <20070728230609.43273a75.diegocg@gmail.com>
In-Reply-To: <20070728230609.43273a75.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708062355.26383.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 July 2007 14:06, Diego Calleja wrote:
> El Sat, 28 Jul 2007 13:07:05 -0700, Bill Huey (hui) escribió:
> The main problem is clearly that no scheduler was clearly better than
> the other. This remembers me of the LVM2/MD vs EVMS in the 2.5 days -
> both of them were good enought, but only one of them could be merged.
> The difference is that EVMS developers didn't get that annoyed, and
> not only they didn't quit but they continued developing their
> userspace tools to make it work with the solution included in the
> kernel
> > (http://lwn.net/Articles/14714/) 

Not that I want to be in this thread, particularly since it is already 
two weeks stale, but your take on the EVMS story is incorrect.  The 
EVMS developers (that is, Kevin) sent out a nice, conciliatory email, 
the project sputtered on for a while, then basically died.

    http://marc.info/?l=evms-devel&m=118240945708775&w=2

Bill is right.  People who know people are right.  A lot of good talent 
has been lost to Linux over the years because of various, perhaps good 
intentioned, gaffs.  The thing is, if you contribute to a project like 
Linux for fun, when it stops being fun you walk.

Regards,

Daniel
