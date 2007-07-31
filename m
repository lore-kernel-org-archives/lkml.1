Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbXGaKFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbXGaKFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbXGaKFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:05:39 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:54323
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbXGaKFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:05:39 -0400
Date: Tue, 31 Jul 2007 03:05:11 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Sescher <gesacs@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       CK Mailinglist <ck@vds.kolivas.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070731100511.GI32582@gnuppy.monkey.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185588279.1654.1.camel@localhost> <20070729150436.GA6598@elte.hu> <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com> <alpine.LFD.0.999.0707291612410.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707291612410.3442@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 04:18:18PM -0700, Linus Torvalds wrote:
> Ingo posted numbers. Look at those numbers, and then I would suggest some 
> people could seriously consider just shutting up. I've seen too many 
> idiotic people who claim that Con got treated unfairly, without those 
> people admitting that maybe I had a point when I said that we have had a 
> scheduler maintainer for years that actually knows what he's doing.

Here's the problem, *a lot* of folks can do scheduler development in and
outside community, so what's with exclusive-only attitude towards the
scheduler ?

There's sufficient effort coming from folks working on CFS from many
sources so how's sched-plugin a *threat* to stock kernel scheduler
development if it gets to the main tree as the default compile option ??

Those are the core question that Con brought in the APC article, folks
are angry because and nobody central to the current Linux has address
this and instead focused on a single narrow set of technical issues
to justify a particular set of actions.

I mean, I'm not the only that has said this so there has to be some
kind of truth behind it.

bill

