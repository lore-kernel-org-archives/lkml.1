Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbXLLKPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbXLLKPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXLLKPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:15:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59100 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbXLLKPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:15:47 -0500
Date: Wed, 12 Dec 2007 11:15:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/timer.c section fixes
Message-ID: <20071212101529.GG24246@elte.hu>
References: <20071211222258.GU14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211222258.GU14204@stusta.de>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes the following section mismatches with 
> CONFIG_HOTPLUG=n, CONFIG_HOTPLUG_CPU=y:

thanks, applied.

	Ingo
