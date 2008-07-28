Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYG1MiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYG1MiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYG1MiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:38:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36773 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYG1MiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:38:07 -0400
Date: Mon, 28 Jul 2008 14:37:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Fix SCHED_HRTICK dependency
Message-ID: <20080728123749.GE5515@elte.hu>
References: <87wsj71sad.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wsj71sad.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3819]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Hi,
> 
> Currently, it seems SCHED_HRTICK allowed for !SMP. But, it seems to 
> have no dependency of it. So how about the following?

applied to tip/sched/urgent, thanks!

	Ingo
