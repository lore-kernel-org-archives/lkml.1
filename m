Return-Path: <linux-kernel-owner+w=401wt.eu-S965509AbXEGQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509AbXEGQA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965254AbXEGQA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:00:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934378AbXEGQA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:00:26 -0400
Date: Mon, 7 May 2007 17:55:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Esben Nielsen <nielsen.esben@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20070507155559.GA26856@elte.hu>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire> <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org> <20070506082911.GA32644@elte.hu> <alpine.LFD.0.98.0705061037390.25245@woody.linux-foundation.org> <Pine.LNX.4.64.0705071311040.14011@frodo.shire>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705071311040.14011@frodo.shire>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Esben Nielsen <nielsen.esben@googlemail.com> wrote:

> I would hate to tell mission control for Mankind's first mission to 
> another star to reboot every 200 years because "there is no need to 
> worry about it."

ok, i need no other argument - fixed :-)

(btw., if anyone from the planning committee of Mankind's first mission 
to another star has any other particular wish about CFS's design, i'm 
all ears and it's going to get the highest possible priority!)

i really mean it! (And i guess you discovered my weak spot. Darn :) 
Hopefully they wont ask for STREAMS support, that would put us into a 
_really_ difficult position.)

	Ingo
