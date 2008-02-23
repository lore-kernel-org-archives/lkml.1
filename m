Return-Path: <linux-kernel-owner+w=401wt.eu-S934466AbYBWKY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934466AbYBWKY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYBWKYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:24:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58407 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbYBWKYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:24:17 -0500
Date: Sat, 23 Feb 2008 11:23:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: don't make swapper_pg_pmd global
Message-ID: <20080223102353.GI23833@elte.hu>
References: <20080222195837.GI1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222195837.GI1409@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Adrian Bunk <bunk@kernel.org> wrote:

> There doesn't seem to be any reason for swapper_pg_pmd being global.

thanks, applied.

	Ingo
