Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbXJQSGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbXJQSGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbXJQSGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:06:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46061 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbXJQSGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:06:47 -0400
Date: Wed, 17 Oct 2007 20:06:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] paravirt_ops and xen updates for 2.6.24
Message-ID: <20071017180626.GA9307@elte.hu>
References: <47150D5E.6090504@goop.org> <47164C89.60400@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47164C89.60400@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0331]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Jeremy Fitzhardinge wrote:
> > Hi Linus,
> >   
> 
> Ping?
> 
> > Please pull:
> >
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-upstream
> >
> > This contains updates for arch/x86 paravirt_ops and Xen.

hm, could we do the arch/x86 changes via the arch/x86 tree instead? 
We've got about a 100 patches pending there now, under QA, preparing 
them for pushout. Will check your paravirt patches too, ok?

	Ingo
