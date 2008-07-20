Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbYGTSNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbYGTSNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 14:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYGTSNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 14:13:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:60757 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780AbYGTSNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 14:13:10 -0400
Subject: Re: [PATCH] x86-kernel: declare some functions before they get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20080720174018.GA16827@elte.hu>
References: <1216050964.2719.4.camel@jaswinder.satnam>
	 <20080720174018.GA16827@elte.hu>
Content-Type: text/plain; charset=utf8
Date: Sun, 20 Jul 2008 23:42:07 +0530
Message-Id: <1216577527.2706.13.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Sun, 2008-07-20 at 19:40 +0200, Ingo Molnar wrote:
> * Jaswinder Singh <jaswinder@infradead.org> wrote:
> 
> > x86-kernel: declare some functions before they get used
> 
> i like this cleanup - would you mind to do a version of this patch that 
> applies to Linus's latest -git tree?
> 

I divided this patch into many parts.

You already applied ﻿'[PATCH] x86: Introducing asm-x86/traps.h' to ﻿tip/x86/core.

and ﻿'[PATCH] Introducing asm/syscalls.h' is on the floor, I
received ﻿Acked-by: Ralf Baechle <ralf@linux-mips.org> and waiting for
other Acks.

If you merge ﻿﻿'[PATCH] Introducing asm/syscalls.h' to
your ﻿tip/x86/core then I will send you updated patch of '[PATCH]
x86-kernel: declare some functions before they get used' based upon on
your latest tip/x86/core git tree.

If Linus add this ﻿'[PATCH] Introducing asm/syscalls.h' in his tree
then ﻿I will send you updated patch of '[PATCH] x86-kernel: declare some
functions before they get used' based upon on latest Linus git tree.

Please let me know which option is better.

Thank you,

Jaswinder Singh.

