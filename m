Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZATHYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZATHYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZATHYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:24:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41736 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZATHYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:24:11 -0500
Date: Tue, 20 Jan 2009 08:24:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET x86:core/percpu] percpu: move PDA fields to percpu
Message-ID: <20090120072404.GA16426@elte.hu>
References: <1232296759-2253-1-git-send-email-tj@kernel.org> <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com> <4973E938.4010408@kernel.org> <20090119111932.GC18996@elte.hu> <20090119113530.GA13185@elte.hu> <4974838F.4020606@kernel.org> <49754643.5030000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49754643.5030000@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2312]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <htejun@gmail.com> wrote:

> Tejun Heo wrote:
> >> Would you mind to redo these commits on top of that? I tried the conflict 
> >> resolution but it looks quite complex and non-obvious - it would be 
> >> cleaner to have it this way.
> > 
> > Sure, will rebase and repost.
> 
> Okay, updatd & rebased (6b7c38d55587f43bcd2cbce3a98b1c0826982090).
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Pulled into tip/core/percpu, thanks!

	Ingo
