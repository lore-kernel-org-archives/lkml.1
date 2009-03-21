Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbZCUQjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbZCUQjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbZCUQjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:39:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41268 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154AbZCUQjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:39:13 -0400
Date: Sat, 21 Mar 2009 17:39:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: mpparse introduce some more helper
	functions
Message-ID: <20090321163908.GJ11183@elte.hu>
References: <1237626755.26347.7.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237626755.26347.7.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Log files are available at:
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=shortlog;h=x86/core
> 
> The following changes since commit 7f00a2495bf5b98b097c47be5d6e2d4114ec39bf:
>   Ingo Molnar (1):
>         Merge branches 'x86/cleanups', 'x86/mm', 'x86/setup' and 'linus' into x86/core
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git x86/core
> 
> Jaswinder Singh Rajput (2):
>       x86: mpparse.c introduce smp_dump_mptable helper function
>       x86: mpparse.c introduce check_physptr helper function
> 
>  arch/x86/kernel/mpparse.c |  112 ++++++++++++++++++++++++---------------------
>  1 files changed, 60 insertions(+), 52 deletions(-)

Pulled, thanks Jaswinder!

	Ingo
