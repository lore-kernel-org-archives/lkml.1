Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYLIX4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYLIX4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYLIX4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:56:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbYLIX4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:56:08 -0500
Date: Tue, 9 Dec 2008 15:54:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-parisc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
Subject: Re: setup_arch/arch_get_boot_command_line changes
In-Reply-To: <200812100850.26728.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0812091553250.3340@localhost.localdomain>
References: <200812100850.26728.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Dec 2008, Rusty Russell wrote:
>
> OK, I've folded in all the fixes, thanks.  Git tree is here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-boot-params.git
> 
> Stephen, please include in linux-next.  Clearly this hits every arch.  I'll
> try to avoid rebasing unless I've broken some arch horribly.

This looks really invasive, with absolutely zero explanations of what the 
point of it all is.

What?

		Linus
