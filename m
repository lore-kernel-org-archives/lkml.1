Return-Path: <linux-kernel-owner+w=401wt.eu-S934123AbYD1Mic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbYD1Mic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765702AbYD1MiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:38:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50350 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763457AbYD1MiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:38:22 -0400
Date: Mon, 28 Apr 2008 14:38:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: x86: fix a couple of sparse warnings
Message-ID: <20080428123809.GD27997@elte.hu>
References: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0500]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> Hi Ingo, Peter, Thomas,
> 
> Here is a couple of patches that fix sparse warnings produced while 
> compiling defconfig for i386:

thanks Dmitri, applied.

	Ingo
