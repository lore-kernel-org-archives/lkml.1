Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbYI3JtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbYI3JtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYI3JtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:49:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54174 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbYI3JtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:49:14 -0400
Date: Tue, 30 Sep 2008 11:49:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] - New UV genapic functions for x2apic
Message-ID: <20080930094904.GA3663@elte.hu>
References: <20080929134529.GA12829@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929134529.GA12829@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0014]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> Add functions that use the infrastructure added by the x2apic code. These
> functions were originally stubbed out since the UV code went into the
> tree prior to the x2apic code.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>

applied to tip/x86/core, thanks Jack.

small patch submission request, could you please use this format in 
future patches:

   Subject: [PATCH] x86, UV: new genapic functions for x2apic

instead of:

   Subject: [PATCH] - New UV genapic functions for x2apic

that follows the typical subject line patterns in x86 commits more 
closely. Fixed it up in this patch, no need to resend.

Thanks,

	Ingo
