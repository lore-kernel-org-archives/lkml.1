Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020Ab0A0MR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0A0MR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577Ab0A0MR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:17:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59424 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0A0MRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:17:55 -0500
Date: Wed, 27 Jan 2010 13:17:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       andreas.herrmann3@amd.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 0/5] x86, cacheinfo, amd: L3 Cache Index Disable fixes
Message-ID: <20100127121740.GB4360@elte.hu>
References: <1264172467-25155-1-git-send-email-bp@amd64.org>
 <4B59DF4C.7040608@zytor.com>
 <20100122174049.GC19425@aftab>
 <4B59E507.9060403@zytor.com>
 <20100123065953.GB15774@elte.hu>
 <20100123081132.GB7098@liondog.tnic>
 <20100123090135.GB20056@elte.hu>
 <20100123163223.GA30859@liondog.tnic>
 <20100125170647.GG14274@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125170647.GG14274@aftab>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> Hi Ingo,
> 
> On Sat, Jan 23, 2010 at 05:32:23PM +0100, Borislav Petkov wrote:
> > > Well, if there's a crasher in there, then a minimal fix to address just that 
> > > is preferred for .33 - and that can be tagged for -stable immediately.
> > 
> > As I said earlier, I don't believe we have machines in the wild to
> > practically support the feature yet so we should be OK without a fix.
> > Let me verify that next week and get back to you with a minimal fix in
> > case we have any affected configurations.
> 
> I could verify that we don't need a minimal fix for .33 for the reason above 
> so the 5 fixes for .34 merge window should suffice completely.

Great - thanks for confirming that.

	Ingo
