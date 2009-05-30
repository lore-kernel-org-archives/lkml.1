Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZE3JlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZE3JlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 05:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZE3JlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 05:41:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZE3JlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 05:41:05 -0400
Date: Sat, 30 May 2009 11:40:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: GeunSik Lim <leemgs1@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Fix COMM and MMAP events
	for cpu wide counters
Message-ID: <20090530094031.GB16913@elte.hu>
References: <tip-efb3d17240d80e27508d238809168120fe4b93a4@git.kernel.org> <49b7c2350905291715v2ff53a96o98a0fd195ee27dc9@mail.gmail.com> <4A207C76.20502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A207C76.20502@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> GeunSik Lim wrote:
> >> On Sat, May 30, 2009 at 2:16 AM, tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >> Commit-ID:  efb3d17240d80e27508d238809168120fe4b93a4
> >> Gitweb:     http://git.kernel.org/tip/efb3d17240d80e27508d238809168120fe4b93a4
> > 
> > I have one question about "tip-bot" and "-tip" word.
> > "tip" word is abbreviation. Can anyone explain me meaning  of the "tip" word?
> > Sorry for trivial question.
> > But I always wondered about this abbreviation in private.

-tip is to signal the 'cutting edge/summit' of the trees we are 
maintaining and working on. "define:tip" on google gives:

tip:
  [...]
  peak: the top or extreme point of something (usually a mountain or 
  hill); "the view from the peak was magnificent"; "they clambered 
  to the tip of Monadnock"; "the region is a few molecules wide at 
  the summit"

> T: Thomas
> I: Ingo
> P: hpa

That secondary meaning is valid too ;-)

	Ingo
