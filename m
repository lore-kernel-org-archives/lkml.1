Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbYFDNGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbYFDNGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYFDNGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:06:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38479 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYFDNGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:06:35 -0400
Date: Wed, 4 Jun 2008 15:02:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?J=FCrgen?= Mell <j.mell@t-online.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, hpa@zytor.com, tglx@linutronix.de,
       Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>,
       stable@kernel.org
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Message-ID: <20080604130258.GA20638@elte.hu>
References: <200806011101.06491.j.mell@t-online.de> <20080602213756.GB25114@linux-os.sc.intel.com> <20080602225727.GC25114@linux-os.sc.intel.com> <200806040944.15815.j.mell@t-online.de> <20080604105317.GA17874@elte.hu> <Pine.LNX.4.58.0806040853320.18512@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0806040853320.18512@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > fix applied to tip/x86/urgent. Thanks everyone, nice find!
> 
> Ingo, should this be forward to the stable branch?

yes indeed. Cc:-ed.

	Ingo
