Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbZCBKdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbZCBKdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbZCBKdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:33:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54668 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925AbZCBKdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:33:04 -0500
Date: Mon, 2 Mar 2009 11:32:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git-pull -tip] cpu fixes
Message-ID: <20090302103247.GL20897@elte.hu>
References: <1235828025.3379.4.camel@localhost.localdomain> <1235917536.3797.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235917536.3797.4.camel@localhost.localdomain>
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

> On Sat, 2009-02-28 at 19:04 +0530, Jaswinder Singh Rajput wrote:
> > Hello Ingo,
> > 
> > Please pull:
> > 
> > The following changes since commit c6003015dacd7c6fe18c6009115801079d8fdd49:
> >   Ingo Molnar (1):
> >         Merge branch 'linus'
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> > 
> > Jaswinder Singh Rajput (3):
> >       x86: decent declarations in perf_counter.c
> >       x88: using pr_info in perf_counter.c
> >       x86: remove double copy of show_cpuinfo_core for 32 and 64 bit
> > 
> 
> Hello Ingo,
> 
> 'x86: remove double copy of show_cpuinfo_core for 32 and 64 bit' already
> merged in -tip through peter, So here is new pull request:
> The following changes since commit c6003015dacd7c6fe18c6009115801079d8fdd49:
>   Ingo Molnar (1):
>         Merge branch 'linus'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> 
> Jaswinder Singh Rajput (2):
>       x86: decent declarations in perf_counter.c
>       x86: using pr_info in perf_counter.c
> 
>  arch/x86/kernel/cpu/perf_counter.c |   62 ++++++++++++++++++------------------
>  1 files changed, 31 insertions(+), 31 deletions(-)

i've applied the two patches to tip:perfcounters/core, thanks 
Jaswinder! Note, i did small edits in the changelogs.

	Ingo
