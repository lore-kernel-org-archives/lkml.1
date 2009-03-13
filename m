Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZCMCDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZCMCDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZCMCD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:03:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60554 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbZCMCD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:03:27 -0400
Date: Fri, 13 Mar 2009 03:03:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: cpu_debug support read-write opertaions
	for PMC
Message-ID: <20090313020309.GB18760@elte.hu>
References: <1236807253.15646.11.camel@ht.satnam> <1236842076.12116.7.camel@ht.satnam> <1236843981.12116.11.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236843981.12116.11.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Thu, 2009-03-12 at 12:44 +0530, Jaswinder Singh Rajput wrote:
> > On Thu, 2009-03-12 at 03:04 +0530, Jaswinder Singh Rajput wrote:
> > > Currently I added read-write operations for PMC MSRs for cpu_debug:
> > 
> > Now I made generic write support by adding write flag for registers.
> > currently write is enabled only for PMC MSR but we can also support
> > another MSRs just changing the write flag.
> 
> Here some more cleanups and comment to avoid confusions, and then new
> request pull:
> 
> Log is available at:
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-cpu.git;a=commit;h=1fdb3c7038d8bde067f56d43705ea24e866c9673
> 
> The following changes since commit 8851485ba842e892adfa343463ce6b74550bb8b1:
>   Ingo Molnar (1):
>         Merge branch 'x86/urgent'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git master

Pulled, thanks!

	Ingo
