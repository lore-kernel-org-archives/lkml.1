Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbXFZIyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbXFZIyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXFZIy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:54:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55135 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbXFZIy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:54:28 -0400
Date: Tue, 26 Jun 2007 10:52:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de, kernel@kolivas.org,
       containers@lists.osdl.org, ckrm-tech@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       pwil3058@bigpond.net.au, tong.n.li@intel.com, wli@holomorphy.com,
       linux-kernel@vger.kernel.org, dmitry.adamushko@gmail.com,
       balbir@in.ibm.com, dev@sw.ru
Subject: Re: [PATCH 0/2] Add group awareness to CFS - v2
Message-ID: <20070626085233.GB1824@elte.hu>
References: <20070623131545.GA5297@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623131545.GA5297@linux.vnet.ibm.com>
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


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> Hi Ingo,
> 	Here's an update for the group-aware CFS scheduler that I have 
> been working on.

thanks. I've carried your patch #1 (core changes) for the past few days 
and it's looking pretty good so far! This makes the container-scheduling 
patch (patch #2) a pretty painless add-on.

	Ingo
