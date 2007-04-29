Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbXD2LMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbXD2LMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbXD2LMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:12:34 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:55900
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbXD2LMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 07:12:32 -0400
Date: Sun, 29 Apr 2007 04:11:18 -0700
To: Con Kolivas <kernel@kolivas.org>
Cc: tglx@linutronix.de, Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429111118.GA18955@gnuppy.monkey.org>
References: <20070425214704.GA32572@elte.hu> <20070429071627.GC23638@1wt.eu> <1177842654.5791.85.camel@localhost.localdomain> <200704292053.37121.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704292053.37121.kernel@kolivas.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 08:53:36PM +1000, Con Kolivas wrote:
> On Sunday 29 April 2007 20:30, Thomas Gleixner wrote:
> > As a sidenote: I really wonder if anybody noticed yet, that the whole
> > CFS / SD comparison is so ridiculous, that it is not even funny anymore.
> > CFS modifies the scheduler and nothing else, SD fiddles all over the
> > kernel in interesting ways.
> 
> This is a WTF if ever I saw one.

You should look at the progression of SD versus CFS. You'll find the exact
opposite has happened and it's kind of baffling that you'd say something like
that. So I don't know what is coloring your experiences with this.

SD is highly regular patch and cleanly applies into that portion of the kernel.
Folks have been asking from some kind of pluggability for this kind of
development for years and had it repeatedly blocked in various ways. So this
seems quite odd that you'd say something like that.

bill

