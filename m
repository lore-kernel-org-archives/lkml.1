Return-Path: <linux-kernel-owner+w=401wt.eu-S1763248AbZD1RXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763248AbZD1RXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761224AbZD1RXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:23:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49923 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371AbZD1RXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:23:42 -0400
Date: Tue, 28 Apr 2009 19:22:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: david@lang.hm, Tejun Heo <tj@kernel.org>, Dave Airlie <airlied@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
Message-ID: <20090428172226.GA15115@elte.hu>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com> <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org> <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain> <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm> <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So yes, it would be good to automate it:
> 
> > If a tool was available to detect the hardware and create a 
> > config tailored for the box, this use for a default config would 
> > go away
> 
> Yeah, I've wished for that.

Steve (Cc:-ed) submitted such a script last year IIRC. It wasnt 
particularly complex.

	Ingo
