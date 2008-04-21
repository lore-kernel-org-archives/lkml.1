Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbYDUMZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbYDUMZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbYDUMZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:25:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368AbYDUMZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:25:44 -0400
Date: Mon, 21 Apr 2008 14:25:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove NexGen support
Message-ID: <20080421122530.GG6788@elte.hu>
References: <1208724475-15360-1-git-send-email-dmitri.vorobiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208724475-15360-1-git-send-email-dmitri.vorobiev@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> It is claimed that NexGen CPUs were never shipped:
> 
> http://lkml.org/lkml/2008/4/20/179
> 
> Also, the kernel support for these chips has been broken for a long 
> time, the code intended to support NexGen thereby being essentially 
> dead.
> 
> As an outcome of the discussion that can be found using the URL above, 
> this patch removes the NexGen support altogether.
> 
> The changes in this patch survived a defconfig build for i386, a 
> couple of successful randconfig builds, as well as a runtime test, 
> which consisted in booting a 32-bit x86 box up to the shell prompt.

thanks, applied.

	Ingo
