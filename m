Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbXD2Gpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbXD2Gpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 02:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbXD2Gpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 02:45:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:52595 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754986AbXD2Gpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 02:45:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/wDq4jf0nwejsulDnHjsx7Bqg1Jgz2oWw9pb4uec
	ljK71jIxLngToN
Subject: Re: [patch] CFS scheduler, -v6
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070429053022.GB23638@1wt.eu>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost>  <20070429053022.GB23638@1wt.eu>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 08:45:47 +0200
Message-Id: <1177829148.6264.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 07:30 +0200, Willy Tarreau wrote:

> I don't know if Mike still has problems with SD...

I'm neither testing recent SD releases nor looking at the source.  All
the testing I did was a waste of my time and lkml bandwidth.

	-Mike

