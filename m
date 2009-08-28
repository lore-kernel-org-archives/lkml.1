Return-Path: <linux-kernel-owner+w=401wt.eu-S1752396AbZH1If4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbZH1If4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 04:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZH1Ifz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 04:35:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54057 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZH1Ify (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 04:35:54 -0400
Date: Fri, 28 Aug 2009 10:35:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.31-rc8
Message-ID: <20090828083545.GA3454@elte.hu>
References: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain> <4A9793CF.6010406@nets.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9793CF.6010406@nets.rwth-aachen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Arnd Hannemann <hannemann@nets.rwth-aachen.de> wrote:

> Hi Linus,
> 
> Linus Torvalds wrote.
> > This should be the last -rc, and it's really been quieting down. There's 
> > 131 commits there, and it's all pretty trivial. For example, in the 
> > dirstat below, most of the arch/x86 changes are due to some vmlinux.lds.S 
> > changes to fix problems with older binutils, not actual code changes. And 
> > on powerpc, it's all the ps3 defconfig update.
> 
> I wonder why the one liner
> http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=d560bc61575efae43595cbcb56d0ba3b9450139c
> did not went in. It fixes a regression from 2.6.30:
> http://bugzilla.kernel.org/show_bug.cgi?id=14062

It missed the previous push by a few hours - will send it today or 
tomorrow.

	Ingo
