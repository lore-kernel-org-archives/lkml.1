Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbXD2LsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbXD2LsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbXD2LsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:48:14 -0400
Received: from www.osadl.org ([213.239.205.134]:37526 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755198AbXD2LsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 07:48:13 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Con Kolivas <kernel@kolivas.org>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <200704292053.37121.kernel@kolivas.org>
References: <20070425214704.GA32572@elte.hu> <20070429071627.GC23638@1wt.eu>
	 <1177842654.5791.85.camel@localhost.localdomain>
	 <200704292053.37121.kernel@kolivas.org>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 13:50:18 +0200
Message-Id: <1177847418.5791.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 20:53 +1000, Con Kolivas wrote:
> On Sunday 29 April 2007 20:30, Thomas Gleixner wrote:
> > As a sidenote: I really wonder if anybody noticed yet, that the whole
> > CFS / SD comparison is so ridiculous, that it is not even funny anymore.
> > CFS modifies the scheduler and nothing else, SD fiddles all over the
> > kernel in interesting ways.
> 
> This is a WTF if ever I saw one.

Sorry. My dumbness. I went into the wrong directory to run the diffstat.
It had the full ck set applied.

	tglx

/me goes off to clean the harddisk


