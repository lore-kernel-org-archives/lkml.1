Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZDVL1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZDVL1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZDVL0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:26:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48331 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZDVL0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:26:46 -0400
Date: Wed, 22 Apr 2009 13:26:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
Message-ID: <20090422112612.GA3799@elte.hu>
References: <49EEDAF0.2010507@cosmosbay.com> <20090422101318.GA6630@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422101318.GA6630@ff.dom.local>
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


* Jarek Poplawski <jarkao2@gmail.com> wrote:

> On 22-04-2009 10:53, Eric Dumazet wrote:
> ...
> > If this could be done without recursion, I am pretty sure 
> > netfilter and network guys would have done it. I found Linus 
> > reaction quite shocking IMHO, considering hard work done by all 
> > people on this.
> 
> Right, looks like 100% (Scandinavian?!) troll. I wonder where is 
> the admin of this mess...

You might disagree with me on an honest technical basis, but note 
that this kind of childish, knee-jerk reaction against dissenting 
people is what gives netdev its bad reputation.

	Ingo
