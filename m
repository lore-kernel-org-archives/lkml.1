Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXDZDvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXDZDvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 23:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbXDZDvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 23:51:06 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176AbXDZDvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 23:51:03 -0400
Date: Wed, 25 Apr 2007 20:49:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-Id: <20070425204940.f1899bdf.akpm@linux-foundation.org>
In-Reply-To: <20070426032923.GB1548@wotan.suse.de>
References: <20070425214704.GA32572@elte.hu>
	<20070426032923.GB1548@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 05:29:27 +0200 Nick Piggin <npiggin@suse.de> wrote:

> >  - upstream fix: SysRq-T should show runnable tasks
> 
> BTW. can you send this upstream? It is very annoying how it currently works,
> and I've had more than one bug that required seeing runnable tasks in order
> to diagnose and fix...

I have it.  I'm just waiting to see if Linus took it.  Seems not.
