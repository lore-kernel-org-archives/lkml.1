Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbYAXWTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbYAXWTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbYAXWTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:19:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48470 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbYAXWTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:19:10 -0500
Date: Thu, 24 Jan 2008 22:17:47 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, ananth@in.ibm.com,
       dhowells@redhat.com, jdike@addtoit.com, sam@ravnborg.org,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net
Subject: Re: [patch 02/26] Fix ARM to play nicely with generic Instrumentation menu
Message-ID: <20080124221747.GB10388@flint.arm.linux.org.uk>
References: <20080124202706.250598537@polymtl.ca> <20080124203333.128025422@polymtl.ca> <20080124211259.GA10388@flint.arm.linux.org.uk> <20080124212343.GB2181@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124212343.GB2181@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 04:23:43PM -0500, Mathieu Desnoyers wrote:
> * Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> > On Thu, Jan 24, 2008 at 03:27:08PM -0500, Mathieu Desnoyers wrote:
> > > The conflicting commit for 
> > > move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
> > > is the ARM fix from Linus :
> > > 
> > > commit 38ad9aebe70dc72df08851bbd1620d89329129ba
> > 
> > Since we have changes which depend on the location of these options,
> > please hold off until the ARM tree merges in the next window:
> > 
> 
> Can you add me to the CC list of this patch please ?

Not really because it's merged, and any discussion happened a few months
back (though it was updated when Linus fixed your broken changes.)

You can read the patch set at 2007-12-17, via:

http://lists.arm.linux.org.uk/lurker/search/20380101.000000.00000000@ml:linux-arm-kernel,kprobes.en.html

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
