Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbXDYWNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbXDYWNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbXDYWNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:13:12 -0400
Received: from mail1.panix.com ([166.84.1.72]:50657 "EHLO mail1.panix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbXDYWNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:13:10 -0400
Date: Wed, 25 Apr 2007 15:13:05 -0700 (PDT)
From: Kenneth Crudup <kenny@panix.com>
To: Adrian Bunk <bunk@stusta.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425192512.GZ3468@stusta.de>
Message-ID: <Pine.LNX.4.64.0704251512200.8406@vaio.localdomain>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de>
 <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de>
 <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
 <20070425192512.GZ3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Apr 2007, Adrian Bunk wrote:

> Some people might boot Windows between suspending and resuming.

Oh yeah- that, too. Since iTunes doesn't work well with VMWare, I do this
all the time.

	-Kenny

-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Los Angeles
O: 3630 S. Sepulveda Blvd. #138, L.A., CA 90034-6809      (888) 454-8181
