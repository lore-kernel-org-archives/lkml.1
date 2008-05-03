Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbYECQzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbYECQzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 12:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760128AbYECQzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 12:55:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47110 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760060AbYECQzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 12:55:37 -0400
Date: Sat, 3 May 2008 18:55:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       Guillaume Chazarain <guichaz@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] sched_clock_cpu()
Message-ID: <20080503165511.GA21967@elte.hu>
References: <1209832169.6929.42.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209832169.6929.42.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> it _DOESN'T_ boot ;-/ [...]

FYI, the merged version against sched-devel.git does boot fine here and 
the clock does seem to advance as expected.

	Ingo
