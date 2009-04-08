Return-Path: <linux-kernel-owner+w=401wt.eu-S1764105AbZDHS1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764105AbZDHS1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZDHS1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:27:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42452 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbZDHS1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:27:09 -0400
Date: Wed, 8 Apr 2009 11:27:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dipankar@in.ibm.com, niv@us.ibm.com,
       manfred@colorfullife.com, peterz@infradead.org, lethal@linux-sh.org,
       kernel@wantstofly.org, andi@firstfloor.org, kyle@mcmartin.ca,
       deller@gmx.de, davem@davemloft.net, ralf@linux-mips.org, jes@sgi.com,
       benh@kernel.crashing.org, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH -tip] Convert CONFIG_SMP=y powerpc defconfigs to
	TREE_RCU.
Message-ID: <20090408182703.GF6745@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <3181463559098978317@unknownmsgid> <625fc13d0904040621g7b89cd2cq9681ce80635a65c4@mail.gmail.com> <20090404163149.GC6893@linux.vnet.ibm.com> <20090405101756.GA10490@elte.hu> <20090405164420.GI6893@linux.vnet.ibm.com> <20090408124623.GH18581@elte.hu> <20090408174841.GE6745@linux.vnet.ibm.com> <20090408181005.GA2784@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408181005.GA2784@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 08:10:05PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > So no, there's no requirement to touch defconfigs - to the 
> > > contrary: it has way too wide of a cross section with other 
> > > trees to be really practical to carry in the RCU tree.
> > 
> > Sounds good to me!!!  So, is http://lkml.org/lkml/2009/4/3/561 
> > sufficient, or should I repost?
> 
> I have queued up your patch:
> 
>  31c9a24: RCU: make treercu be default
> 
> ... a week ago :-)

Color me slow, stupid, and oblivious!  ;-)

Thank you for applying it!

							Thanx, Paul
