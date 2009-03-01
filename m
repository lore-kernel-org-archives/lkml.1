Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbZCAJpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbZCAJpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZCAJo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:44:56 -0500
Received: from www.tglx.de ([62.245.132.106]:48785 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbZCAJoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:44:55 -0500
Date: Sun, 1 Mar 2009 10:43:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [patch 0/4] genirq: add infrastructure for threaded interrupt
 handlers V2
In-Reply-To: <20090228221040.GA7797@infradead.org>
Message-ID: <alpine.LFD.2.00.0903011043160.29264@localhost.localdomain>
References: <20090226131336.423054348@linutronix.de> <20090228221040.GA7797@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Feb 2009, Christoph Hellwig wrote:

> On Thu, Feb 26, 2009 at 01:28:02PM -0000, Thomas Gleixner wrote:
> > This patch series implements support for threaded irq handlers for the
> > generic IRQ layer.
> 
> What tree is this again?  Patch number two fails to apply again
> mainline.

http://tglx.de/~tglx/patches.tar.bz2

is against mainline.

   tglx
 
