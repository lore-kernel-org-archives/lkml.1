Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbYGOEEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbYGOEEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYGOED7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:03:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbYGOED6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:03:58 -0400
Date: Mon, 14 Jul 2008 22:51:49 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
Message-ID: <20080715025149.GA6137@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080714135034.GA7013@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714135034.GA7013@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 03:50:35PM +0200, Ingo Molnar wrote:
 > Linus,
 > 
 > Please pull the latest x86 git tree from:
 > 
 >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/for-linus
 > 
 > this is our first merge window since we migrated over to a pure Git 
 > based patch management setup and integrated x86.git into the -tip tree. 
 > Going from Quilt to Git was quite hard for this 
 > 1000-patches-per-kernel-cycle tree, so please bear with us :-)
 > 
 > 42 individual x86 topic trees arose in the past development cycle:
 > 
 >  x86/amd-iommu, x86/apic, x86/apm, x86/bitops, x86/build, x86/cleanups,
 >  x86/core, x86/cpa, x86/cpu, x86/debug, x86/defconfig, x86/delay,
 >  x86/fixmap, x86/gart, x86/generalize-visws, x86/i8259, x86/idle, x86/intel,
 >  x86/irq, x86/irqstats, x86/kconfig, x86/ldt, x86/mce, x86/memtest, x86/mmio,
 >  x86/mpparse, x86/nmi, x86/numa, x86/numa-fixes, x86/oprofile, x86/pat,
 >  x86/ptemask, x86/ptrace, x86/resumetrace, x86/setup, x86/threadinfo,
 >  x86/timers, x86/unify-lib, x86/unify-pci, x86/uv, x86/vdso, x86/xen.
 > 
 > .. carrying a total of 820 (non-git-merge) commits from 70 authors.

Wow.

6924d1ab8b7bbe5ab416713f5701b3316b2df85b is a work of art.
Is it ascii-art tetris? a magic eye picture? you decide!

It looks even more spectacular in gitk.

	Dave

-- 
http://www.codemonkey.org.uk
