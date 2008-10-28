Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbYJ1Tzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbYJ1Tzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYJ1TzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:55:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54796 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbYJ1TzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:55:24 -0400
Date: Tue, 28 Oct 2008 20:55:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix init_memory_mapping for [dc000000 - e0000000)
	- v2
Message-ID: <20081028195510.GB29782@elte.hu>
References: <490406FD.30604@kernel.org> <20081027165028.GB30573@linux-os.sc.intel.com> <20081027175547.GE3046@elte.hu> <49067058.7010106@kernel.org> <20081028092737.GT15734@elte.hu> <20081028093930.GA9699@elte.hu> <20081028094758.GA11958@elte.hu> <4906E048.6060006@kernel.org> <20081028095244.GY15734@elte.hu> <49076A6B.4020904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49076A6B.4020904@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: change over-mapping to precise mapping, fix /proc/meminfo 
> output
> 
> v2: fix less 1G ram system handling

applied to tip/x86/urgent, thanks Yinghai!

	Ingo
