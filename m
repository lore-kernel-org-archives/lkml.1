Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbYGCMtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbYGCMtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYGCMti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:49:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52105 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYGCMth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:49:37 -0400
Date: Thu, 3 Jul 2008 14:49:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] ftrace: prevent ftrace modifications while being
	kprobe'd
Message-ID: <20080703124919.GA8759@elte.hu>
References: <485D45AB.3000405@gmail.com> <20080623201525.GA10386@elte.hu> <863e9df20806232029x6621ff13qd584591214e93d7f@mail.gmail.com> <20080626123329.GQ29619@elte.hu> <4863D02F.4070205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4863D02F.4070205@gmail.com>
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


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> Ingo Molnar wrote:
> > best would be a delta patch against tip/master to fix up whatever is 
> > still missing.
> 
> Here is the merge fixup for tip/master (and tip/tracing/ftrace).
> 
> Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>

applied to tip/tracing/ftrace - thanks Abhishek!

	Ingo
