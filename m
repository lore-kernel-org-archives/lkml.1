Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYIVLKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYIVLKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYIVLKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:10:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49918 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbYIVLKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:10:21 -0400
Date: Mon, 22 Sep 2008 13:10:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86: use WARN_ONCE in workaround for mtrr mask
Message-ID: <20080922111005.GE5987@elte.hu>
References: <1221849904-8856-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221849904-8856-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0022]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> so could help to catch attention about bug in bios about mtrr mask setting
> 
> WARN_ONCE get into mainline already. let use it.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/debug, thanks Yinghai!

	Ingo
