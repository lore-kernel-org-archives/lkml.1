Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbYGAIfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbYGAIfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbYGAIfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:35:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432AbYGAIfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:35:02 -0400
Date: Tue, 1 Jul 2008 10:34:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Message-ID: <20080701083446.GA4281@elte.hu>
References: <86802c440806300034x5bb9b7a1s168bbeaee17e5124@mail.gmail.com> <1214812303.3187.10.camel@caritas-dev.intel.com> <86802c440806300215w31abbcb3h6a42395e11701713@mail.gmail.com> <1214818706.23677.8.camel@caritas-dev.intel.com> <86802c440806301205y35563326rd2ada495a0024441@mail.gmail.com> <20080630191628.GA15366@elte.hu> <86802c440806301553y240b020bh9dc448e8085fe60d@mail.gmail.com> <86802c440806301620hafa3ee3k8c5dbe6c45188d69@mail.gmail.com> <1214874582.27760.0.camel@caritas-dev.intel.com> <86802c440806301821j4d9b100cte6a3e0aee5e3867b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806301821j4d9b100cte6a3e0aee5e3867b@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >> Ying,
> >> please check the attached patch
> >
> > Which git-x86 head should I use to test the patch? It can not be applied
> > to x86/master.
> 
> tip/master

hm, tip/master should be exactly the same thing as x86/master. (the 
x86.git repository is a symlink to tip.git on kernel.org)

	Ingo
