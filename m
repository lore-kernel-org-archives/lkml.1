Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbYEABRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbYEABRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYEABR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:17:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56653 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYEABR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:17:27 -0400
Date: Thu, 1 May 2008 03:17:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080501011703.GA27574@elte.hu>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430230100.GK29330@cs181133002.pp.htv.fi>
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

> This breakage with your .config is *not* caused by an input bug as you 
> wrongly claim (I'll send a correct fix after some testing).

I have no opinion about where the bug is (input or leds or elsewhere) - 
my only opinion is that the kernel must not stay build-broken - and the 
discussion with Dmitry was about that.

I'm not interested in trivial patches as those issues are much more 
efficiently handled by the person who maintains that code (i.e. Dmitry) 
and who intimately knows the dependencies and expectations of that code. 
That's why i sent the bugreport and patch to Dmitry.

	Ingo
