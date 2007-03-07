Return-Path: <linux-kernel-owner+w=401wt.eu-S1030502AbXCGJGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbXCGJGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXCGJGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:06:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48657 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030502AbXCGJGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:06:39 -0500
Date: Wed, 7 Mar 2007 10:05:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7 -rt] powerpc 2.6.20-rt8: fix build breakage for PowerPC(ppc64)
Message-ID: <20070307090550.GA1783@elte.hu>
References: <yyik5xt27c0.wl@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yyik5xt27c0.wl@toshiba.co.jp>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Tsutomu OWA <tsutomu.owa@toshiba.co.jp> wrote:

> 
> Hi Ingo,
> 
>   Please apply.
> 
>   This series of patches fixes build breakage on arch/powerpc with 
> realtime preempt patch.  This applies on top of linux-2.6.20 and 
> patch-2.6.20-rt8.

thanks, applied - these fixes all look straightforward and clean.

	Ingo
