Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZFATwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZFATwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZFATwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:52:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbZFATwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:52:24 -0400
Date: Mon, 1 Jun 2009 15:51:03 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Tejun Heo <tj@kernel.org>, JBeulich@novell.com, andi@firstfloor.org,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, ink@jurassic.park.msu.ru,
       rth@twiddle.net, linux@arm.linux.org.uk, hskinnemoen@atmel.com,
       cooloney@kernel.org, starvik@axis.com, jesper.nilsson@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
       takata@linux-m32r.org, geert@linux-m68k.org, monstr@monstr.eu,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Subject: Re: [GIT PATCH core/percpu] percpu: convert most archs to dynamic
	percpu, take#2
Message-ID: <20090601195103.GA6280@bombadil.infradead.org>
References: <1243846708-805-1-git-send-email-tj@kernel.org> <20090601161028.GA30851@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601161028.GA30851@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 12:10:28PM -0400, Kyle McMartin wrote:
> On Mon, Jun 01, 2009 at 05:58:21PM +0900, Tejun Heo wrote:
> >  arch/parisc/kernel/irq.c                         |    2 
> >  arch/parisc/kernel/topology.c                    |    2 
> 
> Ack the parisc bits, they build correctly, and appear to boot fine
> as well (at least, limited testing.)
> 

I appear to have spoken too soon (or booted the wrong machine.) I'll
look into it.
