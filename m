Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYLCShy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYLCShy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYLCShq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:37:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:56233 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYLCShq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,709,1220252400"; 
   d="scan'208";a="470812822"
From: "Luck, Tony" <tony.luck@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Richard Henderson <rth@twiddle.net>, Russell King <rmk@arm.linux.org.uk>,
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
Date: Wed, 3 Dec 2008 10:37:25 -0800
Subject: RE: [RFC 5/8] param: arch_get_boot_command_line() (take II)
Thread-Topic: [RFC 5/8] param: arch_get_boot_command_line() (take II)
Thread-Index: AclU9jgbW+ghsvGvQ1uVwsVa7f9gAQAf35QA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35C6C96C3@orsmsx505.amr.corp.intel.com>
References: <200812012326.03151.rusty@rustcorp.com.au>
 <200812031350.46794.rusty@rustcorp.com.au>
In-Reply-To: <200812031350.46794.rusty@rustcorp.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (All patches can be found in the git tree.  Please test your arch before
> I break it in linux-next ;)
>       git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-boot-params.git )

I pulled your git tree.  All my test configs build cleanly
for ia64 ... but sadly the first kernel I tested (generic_defconfig)
doesn't boot (no console output at all).

I'll see if I can figure out what is going on.

-Tony
