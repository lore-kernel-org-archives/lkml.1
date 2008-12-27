Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYL0J7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYL0J7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYL0J7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:59:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYL0J7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:59:40 -0500
Date: Sat, 27 Dec 2008 10:59:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, randy.dunlap@oracle.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Eliminate atleast 10684 sparse warnings
Message-ID: <20081227095904.GC8248@elte.hu>
References: <1230371496.3276.4.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230371496.3276.4.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Impact: cleanup, avoid 10000+ sparse warnings

:-)

>  include/linux/poison.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/safe-poison-pointers, thanks Jaswinder!

	Ingo
