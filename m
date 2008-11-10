Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYKJNKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYKJNKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYKJNKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:10:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232AbYKJNKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:10:07 -0500
Date: Mon, 10 Nov 2008 14:09:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
	controller
Message-ID: <20081110130937.GB32613@elte.hu>
References: <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com> <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com> <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com> <49057ADD.1050705@cn.fujitsu.com> <20081030171622.GA19872@linux.vnet.ibm.com> <20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com> <20081104124937.GB4898@in.ibm.com> <20081104092040.781f9546.randy.dunlap@oracle.com> <20081105032440.GA3298@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105032440.GA3298@in.ibm.com>
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


* Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> I will resend the patch with other corrections you mentioned only if 
> Paul/Ingo want this patch to go in.

yes, please resend the fixed version.

	Ingo
