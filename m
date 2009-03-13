Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZCMBle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZCMBle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757558AbZCMBlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:41:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52137 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550AbZCMBlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:41:11 -0400
Date: Fri, 13 Mar 2009 02:40:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: more debug print out with mtrr
Message-ID: <20090313014052.GB6178@elte.hu>
References: <49B87BE7.3040809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B87BE7.3040809@kernel.org>
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

> Impact: more print out
> 
> remove unneeded mtrr_show
> 
> it will only printout one time by first cpu, so it is not big deal.
> 
> also print out directly from get_mtrr, because it doesn't update mtrr_state.

FYI, this patch is whitespace and line-wrap corrupted, please 
resend.

	Ingo
