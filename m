Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYHOT4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYHOT4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYHOT4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:56:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43947 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYHOT4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:56:40 -0400
Date: Fri, 15 Aug 2008 21:56:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: macro@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] apic fixes, unification continued
Message-ID: <20080815195619.GB25185@elte.hu>
References: <48a5d4a4.0637560a.1985.fffffd73@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48a5d4a4.0637560a.1985.fffffd73@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0077]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

>   Ingo, Maciej,
> 
> here is updated series (well... two patches only :).
> Nothing that new - just fixed the parts wich were
> not well formed in previous series.
> 
> Please review.

looks good to me - applied to tip/x86/apic - thanks Cyrill. Maciej, any 
objections?

	Ingo
