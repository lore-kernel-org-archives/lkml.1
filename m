Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbXGXUGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbXGXUGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbXGXUGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:06:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764086AbXGXUGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:06:19 -0400
Date: Tue, 24 Jul 2007 22:05:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Rui Nuno Capela <rncbc@rncbc.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.22.1-rt5
Message-ID: <20070724200546.GA24964@elte.hu>
References: <20070723210236.GA25104@elte.hu> <46A51D9E.8040104@rncbc.org> <20070724073932.GA18740@elte.hu> <1185305679.16400.17.camel@cmn3.stanford.edu> <1185305725.16400.19.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185305725.16400.19.camel@cmn3.stanford.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> On Tue, 2007-07-24 at 12:34 -0700, Fernando Lopez-Lezcano wrote:
> > On Tue, 2007-07-24 at 09:39 +0200, Ingo Molnar wrote:
> > > * Rui Nuno Capela <rncbc@rncbc.org> wrote:
> > > 
> > > > Maybe I was too quick, but `make all` on is failing here:
> > > 
> > > does -rt6 work better?
> > 
> > Hmmm, -rt6 seems to be gone... was about to download it and it
> > dissapeared. 
> 
> Never mind, I see it migrated back to the main page. 

apparently you caught that 3 seconds window where the .23-rc1-rt1 
release script moved old patches into the older/ directory :-)

	Ingo
