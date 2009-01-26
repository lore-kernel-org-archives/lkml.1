Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZAZTUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZAZTUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZAZTUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:20:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43883 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbZAZTUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:20:33 -0500
Date: Mon, 26 Jan 2009 20:20:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [git pull] x86 fixes
Message-ID: <20090126192016.GA1211@elte.hu>
References: <20090126171723.GA32030@elte.hu> <20090126110539.2000cd30.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126110539.2000cd30.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 26 Jan 2009 18:17:23 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Rusty Russell (2):
> >       ...
> >       work_on_cpu: Use our own workqueue.
> 
> wtf?

an x86 fix depends on it:

7285908: cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write

	Ingo
