Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZDNL44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZDNL44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZDNL4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:56:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39695 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970AbZDNL4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:56:39 -0400
Date: Tue, 14 Apr 2009 13:56:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: tip: Build failure with !CONFIG_TRACE - undefined reference to
	`trace_clock_global'
Message-ID: <20090414115624.GV3558@elte.hu>
References: <20090409173640.GA8211@linux-os.sc.intel.com> <20090410121633.GQ21506@elte.hu> <1239383585.4529.8548.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239383585.4529.8548.camel@localhost.localdomain>
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> On Fri, 2009-04-10 at 05:16 -0700, Ingo Molnar wrote:
> > * Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
> > 
> > > With tip (commit - 58e70a841b20d5d80aebdd8274ab60c0c933470f) I get a build
> > 
> > hm, i dont get this build failure - could you please send the 
> > .config that provokes it?
> > 
> 
> Attached is the problematic config (32 bit).

thanks - should be fixed in latest -tip.

	Ingo
