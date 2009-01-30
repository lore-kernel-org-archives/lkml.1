Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZA3OWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZA3OWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZA3OW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:22:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36956 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbZA3OW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:22:26 -0500
Date: Fri, 30 Jan 2009 15:22:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix compiling with 64bit with def_to_bigsmp
Message-ID: <20090130142208.GB22848@elte.hu>
References: <49827414.2020908@kernel.org> <4982743C.5000200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4982743C.5000200@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fic compiling
> 
> only need to do cut off with 32bit
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/smpboot.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to tip/x86/apic, thanks!

	Ingo
