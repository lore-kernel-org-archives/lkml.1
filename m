Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbYIVLxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbYIVLxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYIVLxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:53:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYIVLxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:53:41 -0400
Date: Mon, 22 Sep 2008 13:53:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] hrtimer: Remove hrtimer_clock_base::reprogram()
Message-ID: <20080922115327.GD14301@elte.hu>
References: <1221826428.20993.6.camel@blaa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221826428.20993.6.camel@blaa>
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


* Mark McLoughlin <markmc@redhat.com> wrote:

> hrtimer_clock_base::reprogram() also appears to never
> have been used, so remove it.
> 
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>

applied to tip/timers/hrtimers, thanks Mark.

Thomas, any objections?

	Ingo
