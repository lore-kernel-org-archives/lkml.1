Return-Path: <linux-kernel-owner+w=401wt.eu-S1759159AbZCUQcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159AbZCUQcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbZCUQb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:31:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbZCUQb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:31:56 -0400
Date: Sat, 21 Mar 2009 17:31:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: cleanup patches 20090321
Message-ID: <20090321163145.GG11183@elte.hu>
References: <1237635931.2409.4.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237635931.2409.4.camel@ht.satnam>
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

> Log files are available at:
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tiptop.git;a=shortlog;h=x86/core
> 
> The following changes since commit 7f00a2495bf5b98b097c47be5d6e2d4114ec39bf:
>   Ingo Molnar (1):
>         Merge branches 'x86/cleanups', 'x86/mm', 'x86/setup' and 'linus' into x86/core
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git x86/core
> 
> Jaswinder Singh Rajput (6):
>       x86: topology.c cleanup
>       x86: kdebugfs.c cleanup
>       x86: i8253 cleanup
>       x86: rtc.c cleanup
>       x86: io_delay.c cleanup
>       x86: pci-nommu.c cleanup
> 
>  arch/x86/kernel/i8253.c     |   68 +++++++++++++++++------------------
>  arch/x86/kernel/io_delay.c  |   27 +++++++-------
>  arch/x86/kernel/kdebugfs.c  |   82 +++++++++++++++++++------------------------
>  arch/x86/kernel/pci-nommu.c |   20 +++++-----
>  arch/x86/kernel/rtc.c       |   20 ++++++-----
>  arch/x86/kernel/topology.c  |   14 ++++---
>  6 files changed, 111 insertions(+), 120 deletions(-)

Pulled, thanks Jaswinder!

	Ingo
