Return-Path: <linux-kernel-owner+w=401wt.eu-S1762414AbXIXSDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762414AbXIXSDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbXIXSC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:02:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42255 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbXIXSC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:02:56 -0400
Date: Mon, 24 Sep 2007 20:01:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, dmitry.adamushko@gmail.com,
       linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       containers@lists.osdl.org, kamezawa.hiroyu@jp.fujitsu.com,
       menage@google.com, efault@gmx.de
Subject: Re: [PATCH 4/5] Add fair-user scheduler
Message-ID: <20070924180155.GA551@elte.hu>
References: <20070924163326.GA10291@linux.vnet.ibm.com> <20070924164059.GE10291@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924164059.GE10291@linux.vnet.ibm.com>
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


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> Enable user-id based fair group scheduling. This is usefull for anyone 
> who wants to test the group scheduler w/o having to enable 
> CONFIG_CGROUPS.

excellent! I'll make this default-enabled.

	Ingo
