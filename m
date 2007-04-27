Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbXD0NTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbXD0NTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbXD0NTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:19:20 -0400
Received: from rtr.ca ([64.26.128.89]:4173 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbXD0NTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:19:19 -0400
Message-ID: <4631F854.20207@rtr.ca>
Date: Fri, 27 Apr 2007 09:19:16 -0400
From: Mark Lord <mark@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
References: <20070425214704.GA32572@elte.hu>
In-Reply-To: <20070425214704.GA32572@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

You've really outdone yourself this time!

2.6.21 + CFS-v6, plus the futex PI fix patch posted later,
just absolutely rocks here!

I'm having a very difficult time finding any fault with it,
and it has now displaced the stock scheduler as my default
and personal favourite.

The KDE (Dapper Drake) desktop is smooth under 100% CPU load,
mp3's play without glitches, and everything is just *so* responsive.

Well done.  Let's get something like this into mainline.
-- 
Mark Lord
Real-Time Remedies Inc.
mark@rtr.ca
