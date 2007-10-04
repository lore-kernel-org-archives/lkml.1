Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbXJDHlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbXJDHlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 03:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXJDHlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 03:41:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbXJDHlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:41:10 -0400
Date: Thu, 4 Oct 2007 09:40:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20071004074056.GB9176@elte.hu>
References: <1191354556.5664.7.camel@earth> <1191355144.5664.16.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191355144.5664.16.camel@earth>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> The following patch (sched: disable sleeper_fairness on SCHED_BATCH) 
> seems to break GROUP_SCHED. Although, it may be 'oops'-less due to the 
> possibility of 'p' being always a valid address.

thanks, applied.

	Ingo
