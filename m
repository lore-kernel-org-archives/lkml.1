Return-Path: <linux-kernel-owner+w=401wt.eu-S1764640AbXFEKoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764640AbXFEKoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764033AbXFEKoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:44:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46748 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764066AbXFEKoN (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:44:13 -0400
Date: Tue, 5 Jun 2007 12:43:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605104353.GA7309@elte.hu>
References: <20070604173710.GR11166@waste.org> <1181002734.25878.56.camel@localhost.localdomain> <1181010675.25878.140.camel@localhost.localdomain> <20070605041803.GO11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605041803.GO11115@waste.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Matt, could you send me your .config too? Maybe i can reproduce it 
with your config.

	Ingo
