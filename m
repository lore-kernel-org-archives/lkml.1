Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYGAIjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYGAIjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYGAIjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:39:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45874 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbYGAIja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:39:30 -0400
Date: Tue, 1 Jul 2008 10:39:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Message-ID: <20080701083913.GB4281@elte.hu>
References: <1214809434.2887.8.camel@caritas-dev.intel.com> <86802c440806300034x5bb9b7a1s168bbeaee17e5124@mail.gmail.com> <1214812303.3187.10.camel@caritas-dev.intel.com> <86802c440806300215w31abbcb3h6a42395e11701713@mail.gmail.com> <1214818706.23677.8.camel@caritas-dev.intel.com> <86802c440806301205y35563326rd2ada495a0024441@mail.gmail.com> <20080630191628.GA15366@elte.hu> <86802c440806301553y240b020bh9dc448e8085fe60d@mail.gmail.com> <86802c440806301620hafa3ee3k8c5dbe6c45188d69@mail.gmail.com> <1214880322.16612.3.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214880322.16612.3.camel@caritas-dev.intel.com>
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


* Huang, Ying <ying.huang@intel.com> wrote:

> On Mon, 2008-06-30 at 16:20 -0700, Yinghai Lu wrote:
> > Ying,
> > please check the attached patch
> > 
> 
> Tested-by: Huang, Ying <ying.huang@intel.com>

applied to tip/x86/unify-setup - thanks!

	Ingo
