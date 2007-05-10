Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbXEJTqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbXEJTqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbXEJTqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:46:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60343 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbXEJTqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:46:04 -0400
Date: Thu, 10 May 2007 21:45:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian <christiand59@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v11
Message-ID: <20070510194552.GA18741@elte.hu>
References: <20070508150431.GA26977@elte.hu> <200705101859.11696.christiand59@web.de> <1178817044.25266.8.camel@localhost> <200705102051.09432.christiand59@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705102051.09432.christiand59@web.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian <christiand59@web.de> wrote:

> [...] Latencies with nice are _worse_ than latencies without nice on 
> my system. [...]

i'll check that - this must be a CFS buglet.

	Ingo
