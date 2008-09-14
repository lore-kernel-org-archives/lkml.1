Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYINOh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYINOh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYINOhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:37:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38196 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbYINOhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:37:17 -0400
Date: Sun, 14 Sep 2008 16:37:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2.6.27-rc6] x86_64 minor HPET tweakage
Message-ID: <20080914143705.GB12522@elte.hu>
References: <200809121018.04427.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809121018.04427.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Minor HPET tweakage on x86_64: Label the /proc/interrupts entry as 
> "hpet" or "pit", matching the device and its clockevent name in 
> /proc/timer_list.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

applied to tip/timers/clockevents - thanks David!

	Ingo
