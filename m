Return-Path: <linux-kernel-owner+w=401wt.eu-S967995AbXEHFj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967995AbXEHFj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967977AbXEHFj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:39:28 -0400
Received: from waste.org ([66.93.16.53]:51467 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967882AbXEHFj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:39:27 -0400
Date: Tue, 8 May 2007 00:36:27 -0500
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Esben Nielsen <nielsen.esben@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070508053627.GS11166@waste.org>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire> <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org> <Pine.LNX.4.64.0705071159530.14011@frodo.shire> <alpine.LFD.0.98.0705070921390.3802@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705070921390.3802@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 09:28:32AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 7 May 2007, Esben Nielsen wrote:
> > 
> > What is (long)(a-b) ? I have tried to look it up in the C99 standeard but I
> > can't find it. Maybe it is in the referred LIA-1 standeard, which I can't find
> > with google.
> 
> I don't worry about non-2's-complement machines (they don't exist, and 
> likely won't exist in the future either).

They do exist. And they run Linux. SLES9 in fact.

http://en.wikipedia.org/wiki/UNIVAC_1100/2200_series#UNISYS_ClearPath_IX_series

http://www.unisys.com/eprise/main/admin/corporate/doc/ClearPath_Plus_Dorado_Model_390_Server_Specification_Sheet.pdf

That machine is a direct descendant of the Univac 1101 from 1950 and
is still software-compatible with 1107s from 1962.

(Granted, they only run Linux on the x86 side.)

-- 
Mathematics is the supreme nostalgia of our time.
