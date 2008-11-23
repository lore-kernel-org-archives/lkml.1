Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbYKWLSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbYKWLSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYKWLSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:18:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbYKWLSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:18:38 -0500
Date: Sun, 23 Nov 2008 12:18:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] OProfile fixes for v2.6.28
Message-ID: <20081123111820.GG30453@elte.hu>
References: <20081123110610.GC14700@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123110610.GC14700@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Hi Ingo,
> 
> please pull oprofile fixes for 2.6.28 for tip regression:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git oprofile-for-tip
> 
> There is only one fix:
> 
> Eric Dumazet (1):
>       oprofile: fix an overflow in ppro code
> 
> Thanks,

Pulled into tip/x86/urgent, thanks Robert!

	Ingo
