Return-Path: <linux-kernel-owner+w=401wt.eu-S934888AbZDHSLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888AbZDHSLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbZDHSKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:10:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58760 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758354AbZDHSKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:10:50 -0400
Date: Wed, 8 Apr 2009 20:10:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dipankar@in.ibm.com, niv@us.ibm.com,
       manfred@colorfullife.com, peterz@infradead.org, lethal@linux-sh.org,
       kernel@wantstofly.org, andi@firstfloor.org, kyle@mcmartin.ca,
       deller@gmx.de, davem@davemloft.net, ralf@linux-mips.org, jes@sgi.com,
       benh@kernel.crashing.org, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH -tip] Convert CONFIG_SMP=y powerpc defconfigs to
	TREE_RCU.
Message-ID: <20090408181005.GA2784@elte.hu>
References: <3181463559098978317@unknownmsgid> <625fc13d0904040621g7b89cd2cq9681ce80635a65c4@mail.gmail.com> <20090404163149.GC6893@linux.vnet.ibm.com> <20090405101756.GA10490@elte.hu> <20090405164420.GI6893@linux.vnet.ibm.com> <20090408124623.GH18581@elte.hu> <20090408174841.GE6745@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408174841.GE6745@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > So no, there's no requirement to touch defconfigs - to the 
> > contrary: it has way too wide of a cross section with other 
> > trees to be really practical to carry in the RCU tree.
> 
> Sounds good to me!!!  So, is http://lkml.org/lkml/2009/4/3/561 
> sufficient, or should I repost?

I have queued up your patch:

 31c9a24: RCU: make treercu be default

... a week ago :-)

	Ingo
