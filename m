Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZDDQcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZDDQcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbZDDQb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:31:56 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36688 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbZDDQbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:31:55 -0400
Date: Sat, 4 Apr 2009 09:31:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, niv@us.ibm.com, manfred@colorfullife.com,
       peterz@infradead.org, lethal@linux-sh.org, kernel@wantstofly.org,
       andi@firstfloor.org, kyle@mcmartin.ca, deller@gmx.de,
       davem@davemloft.net, ralf@linux-mips.org, jes@sgi.com,
       benh@kernel.crashing.org, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH -tip] Convert CONFIG_SMP=y powerpc defconfigs to
	TREE_RCU.
Message-ID: <20090404163149.GC6893@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <3181463559098978317@unknownmsgid> <625fc13d0904040621g7b89cd2cq9681ce80635a65c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625fc13d0904040621g7b89cd2cq9681ce80635a65c4@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 09:21:58AM -0400, Josh Boyer wrote:
> On Fri, Apr 3, 2009 at 8:27 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Why would one want to do this?  The commit log doesn't explain the
> switch and why it's great.  Mostly because the commit log doesn't
> exist.  (I'll stop channeling Andrew now)

Indeed, I am sure that I will get the hang the relevant git commands
at some point, but clearly am not yet there.

The thing that is great about this patch is that it is a step on
the way to retiring Classic RCU entirely.

> It also might be a good idea to CC the linuxppc-dev list for this
> patch.  Or at least Kumar for the mpc86xx changes.

Good point -- I will do so on the next version.

							Thanx, Paul
