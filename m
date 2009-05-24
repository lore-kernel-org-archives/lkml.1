Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZEXHK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZEXHK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZEXHKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:10:14 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:35893 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZEXHKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:10:13 -0400
X-Greylist: delayed 1249 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 May 2009 03:10:13 EDT
Date: Sun, 24 May 2009 15:04:15 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090524070415.GI20452@prithivi.gnumonks.org>
References: <200905221139.26941.lkml@morethan.org> <200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com> <200905230544.54657.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905230544.54657.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 05:44:52AM -0500, Michael S. Zick wrote:

> *) The HP-2133 MiniNote uses the cn896 chipset, which
> has not yet been released from NDA.

I can see towards getting that changed, but I doubt this helps us with the
current problem.

> I do not have the C7-M technical reference, it is still
> under NDA.

I obviously have access to that documentation (which is also on its way
to become public, but needs more time) - but believe me, there is nothing
in that documentation that would help you to debug this problem :(

> *But* if a developer on this list has a copy of the
> manual *and* owns one of these three brands of machine -
> they would have fixed their own machine a year ago.

I actually own a 2133 mininote, but I rarely used it for anything but to test
openchrome on it.  What do you suggest me to try?

I also have some other systems with a C7-M, so I can certainly verify
certain code on a number of them, if a good testcase exists.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison
