Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752249AbYLROcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbYLROcN (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 09:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYLROb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 09:31:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33152 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbYLROb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 09:31:57 -0500
Date: Thu, 18 Dec 2008 15:31:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] x86 PAT: v2 - track pfnmap mappings with
	remap_pfn_range and vm_insert_pfn
Message-ID: <20081218143131.GD9051@elte.hu>
References: <20081126002157.475142000@intel.com> <7E82351C108FA840AB1866AC776AEC464338C11E@orsmsx505.amr.corp.intel.com> <20081216195154.GB4501@elte.hu> <20081216220502.GC22722@wotan.suse.de> <20081216220746.GE14787@elte.hu> <20081217081932.GC26179@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217081932.GC26179@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> On Tue, Dec 16, 2008 at 11:07:46PM +0100, Ingo Molnar wrote:
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > > > So when you sent this a month ago i asked the MM folks whether they have 
> > > > any problems with these patches. Acks (or objections) from Andrew, Nick or 
> > > > Hugh would be nice to have.
> > > 
> > > Last I looked at them, I think all my questions were cleared up.
> > 
> > does that transform into a:
> > 
> >   Acked-by: Nick Piggin <npiggin@suse.de>
> 
> I should think so ;), but I'll take another glance at the next round 
> after Andrew's comments were incorporated. Are those available?

not yet available - Venki, would you mind to resend the series with those 
bits fixed, so that Nick can have a look at the end result? Thanks,

	Ingo
