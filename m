Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZA3OWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZA3OWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZA3OV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:21:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36797 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZA3OV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:21:57 -0500
Date: Fri, 30 Jan 2009 15:21:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove left over files
Message-ID: <20090130142145.GA22848@elte.hu>
References: <49827414.2020908@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49827414.2020908@kernel.org>
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

> 
> Impact: cleanup
> 
> remove deaf files
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/bigsmp/apic.h    |  138 ----------------------------------
>  arch/x86/include/asm/bigsmp/apicdef.h |    9 --
>  arch/x86/include/asm/bigsmp/ipi.h     |   22 -----
>  arch/x86/mach-default/Makefile        |    5 -
>  4 files changed, 174 deletions(-)

Applied to tip/x86/apic, thanks Yinghai!

	Ingo
