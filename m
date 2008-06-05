Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYFEM3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYFEM3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbYFEM3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:29:30 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3646 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbYFEM33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:29:29 -0400
X-Greylist: delayed 1872 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 08:29:29 EDT
Date: Thu, 5 Jun 2008 13:57:59 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Chris Dearman <chris@mips.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: mips/kernel/traps.c build error
Message-ID: <20080605115759.GA5043@deprecation.cyrius.com>
References: <20080525164311.GB1791@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525164311.GB1791@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk <bunk@kernel.org> [2008-05-25 19:43]:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/kernel/traps.c: In function 'show_raw_backtrace':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/kernel/traps.c:92: error: cast from pointer to integer of different size
> make[2]: *** [arch/mips/kernel/traps.o] Error 1
> 
> <--  snip  -->
> 
> "[MIPS] Fix check for valid stack pointer during backtrace" in the mips 
> tree fixes it, and should therefore also go into 2.6.26.

It's still not in mainline as of rc5.
-- 
Martin Michlmayr
http://www.cyrius.com/
