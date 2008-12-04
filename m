Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYLDA6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYLDA6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYLDA6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:58:43 -0500
Received: from ozlabs.org ([203.10.76.45]:43041 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbYLDA6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:58:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line() (take II)
Date: Thu, 4 Dec 2008 11:28:32 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
References: <200812012326.03151.rusty@rustcorp.com.au> <200812031350.46794.rusty@rustcorp.com.au> <200812032121.mB3LL13L021817@agluck-lia64.sc.intel.com>
In-Reply-To: <200812032121.mB3LL13L021817@agluck-lia64.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812041128.34159.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008 05:07:25 Luck, Tony wrote:
> > I pulled your git tree.  All my test configs build cleanly
> > for ia64 ... but sadly the first kernel I tested (generic_defconfig)
> > doesn't boot (no console output at all).
> >
> > I'll see if I can figure out what is going on.
>
> Aha.

OK, both appended to git tree.  
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-boot-params.git

If noone else complains, I'll fold the fix and ask Stephen to take the tree 
for linux-next.

Cheers,
Rusty.
