Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYKCJDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYKCJDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYKCJDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:03:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45687 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbYKCJDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:03:38 -0500
Date: Mon, 3 Nov 2008 10:03:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gary Hade <garyhade@us.ibm.com>
Cc: linux-mm@kvack.org, Yasunori Goto <y-goto@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris McDermott <lcm@us.ibm.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [RESEND] x86: add memory hotremove config option
Message-ID: <20081103090315.GH11730@elte.hu>
References: <20081031175203.GA7483@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031175203.GA7483@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gary Hade <garyhade@us.ibm.com> wrote:

> I am resending this patch (originally posted by Badari Pulavarty)
> since the "mm: cleanup to make remove_memory() arch-neutral" patch
> on which it depends is now in Linus' 2.6.git tree (commit
> 71088785c6bc68fddb450063d57b1bd1c78e0ea1) and 2.6.28-rc2.
> 
> Thanks,
> Gary
> 
> ---
> Add memory hotremove config option to x86
> 
> Memory hotremove functionality can currently be configured into
> the ia64, powerpc, and s390 kernels.  This patch makes it possible
> to configure the memory hotremove functionality into the x86
> kernel as well.
> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> Signed-off-by: Gary Hade <garyhade@us.ibm.com>

applied to tip/x86/mm, thanks!

	Ingo
