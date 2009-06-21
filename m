Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZFUKly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZFUKly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 06:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZFUKlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 06:41:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54561 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbZFUKln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 06:41:43 -0400
Date: Sun, 21 Jun 2009 12:41:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [TRIVIAL] Documentation/sched-rt-group: Fix style
	issues & bump version
Message-ID: <20090621104136.GA13503@elte.hu>
References: <1245580359-4465-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245580359-4465-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0192]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wolfram Sang <w.sang@pengutronix.de> wrote:

> -NOTE: the above example is not fully implemented as of yet (2.6.25). We still
> +NOTE: the above example is not fully implemented as of yet (2.6.31). We still

lets just remove the version info, ok?

	Ingo
