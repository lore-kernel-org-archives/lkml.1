Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYHVGCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYHVGCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYHVGCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:02:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45875 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbYHVGCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:02:10 -0400
Date: Fri, 22 Aug 2008 08:01:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Zachary Amsden <zach@vmware.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86: VMI: Fix bug, do_IRQ: cannot handle...
Message-ID: <20080822060148.GE14110@elte.hu>
References: <1219343203.18349.39.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219343203.18349.39.camel@alok-dev1>
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


* Alok Kataria <akataria@vmware.com> wrote:

> Below is the patch which needs to be applied to x86-tip/master, to fix
> the VMI bug caused by 
> commit 9c3f2468d8339866d9ef6a25aae31a8909c6be0d.
> x86: make 32bit support per_cpu vector
> 
> Thanks to Yinghai, for giving a heads up.
> 
> Please apply.

applied to tip/irq/sparseirq, thanks Alok.

	Ingo
