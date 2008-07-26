Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYGZUeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYGZUeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 16:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbYGZUeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 16:34:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42130 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbYGZUeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 16:34:03 -0400
Date: Sat, 26 Jul 2008 22:33:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [git pull] signalfd4 fix
Message-ID: <20080726203349.GA8758@elte.hu>
References: <20080726191434.GA26799@elte.hu> <alpine.LFD.1.10.0807261324310.4188@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807261324310.4188@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 26 Jul 2008, Ingo Molnar wrote:
> > 
> > Please pull a compat_sys_signalfd4 build fix from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus
> 
> Hmm. I already applied this one from email.

ok - thanks. (I zapped this commit from the core/urgent branch to avoid 
the duplicate commit IDs.)

	Ingo
