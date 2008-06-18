Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYFRN1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYFRN1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYFRN1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:27:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51107 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYFRN1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:27:47 -0400
Date: Wed, 18 Jun 2008 15:27:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softlockup: print a module list on being stuck
Message-ID: <20080618132725.GE11501@elte.hu>
References: <20080616155108.2ae7913a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616155108.2ae7913a@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] softlockup: print a module list on being stuck
> 
> Most places in the kernel that go BUG: print a module list (which is 
> very useful for doing statistics and finding patterns), however the 
> softlockup detector does not do this yet.
> 
> This patch adds the one line change to fix this gap.

applied to tip/core/softlockup - thanks Arjan.

	Ingo
