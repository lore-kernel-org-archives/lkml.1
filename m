Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbZDEKgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbZDEKgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 06:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757730AbZDEKgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 06:36:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60022 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZDEKgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 06:36:01 -0400
Date: Sun, 5 Apr 2009 12:37:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dipankar@in.ibm.com, niv@us.ibm.com,
       manfred@colorfullife.com, peterz@infradead.org, lethal@linux-sh.org,
       kernel@wantstofly.org, andi@firstfloor.org, kyle@mcmartin.ca,
       deller@gmx.de, davem@davemloft.net, ralf@linux-mips.org, jes@sgi.com,
       benh@kernel.crashing.org, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH -tip] Convert CONFIG_SMP=y powerpc defconfigs to TREE_RCU.
Message-ID: <20090405103759.GA17934@one.firstfloor.org>
References: <3181463559098978317@unknownmsgid> <625fc13d0904040621g7b89cd2cq9681ce80635a65c4@mail.gmail.com> <20090404163149.GC6893@linux.vnet.ibm.com> <20090405101756.GA10490@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090405101756.GA10490@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd suggest you dont do these dozens of defconfig updates at all - 
> arch maintainers can do this themselves, once the core kernel 
> default has been flipped.

AFAIK they don't. There's no make updatemyconfigwithdefaultstatementsconfig

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
