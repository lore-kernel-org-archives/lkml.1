Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZCWUV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZCWUV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZCWUVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:21:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47948 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZCWUVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:21:19 -0400
Date: Mon, 23 Mar 2009 21:20:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@mcmartin.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] degrade severity of lockdep printk
Message-ID: <20090323202054.GA6395@elte.hu>
References: <20090323201628.GB19208@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323201628.GB19208@bombadil.infradead.org>
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


* Kyle McMartin <kyle@mcmartin.ca> wrote:

> From: Kyle McMartin <kyle@redhat.com>
> 
> While it means something is awry, the BUG prefix confuses users 
> and possibly the kerneloops tool. It's also being trivially 
> exhausted in normal use on my laptop and several other folks 
> machines, but that will need another look.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Please report it in that case and get us to increase the limit.

	Ingo
