Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbZAKBGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbZAKBGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZAKBGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:06:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43563 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbZAKBGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:06:46 -0500
Date: Sun, 11 Jan 2009 02:06:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] irq: change references from NR_IRQS to nr_irqs
Message-ID: <20090111010622.GA12885@elte.hu>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223818.636427000@polaris-admin.engr.sgi.com> <20090110224523.GB17917@elte.hu> <49692AD3.9020401@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49692AD3.9020401@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> Impact: preparation, cleanup
> > 
> > s/Impact: preparation, cleanup/Impact: preparation, cleanup, add printk
> 
> Hmm, should I attempt the 'git rebase -i' to change this or just fix up 
> the patch, and repush (getting new commit ids)?

Your choice really - it's the same end result: different commit IDs. I'd 
suggest the method that is easier to you.

	Ingo
