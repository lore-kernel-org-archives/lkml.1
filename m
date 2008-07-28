Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbYG1MU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbYG1MU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbYG1MUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:20:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45556 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYG1MUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:20:15 -0400
Date: Mon, 28 Jul 2008 14:19:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove find_max_pfn_with_active_regions
Message-ID: <20080728121955.GA5515@elte.hu>
References: <200807271754.33833.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807271754.33833.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> 
> no user now
> 
> also print out info about adding/removing active region
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
