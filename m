Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbXDYV4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbXDYV4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbXDYV4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:56:30 -0400
Received: from waste.org ([66.93.16.53]:53740 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbXDYV4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:56:30 -0400
Date: Wed, 25 Apr 2007 16:41:56 -0500
From: Matt Mackall <mpm@selenic.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425214156.GI11166@waste.org>
References: <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424205416.GA23032@elte.hu> <20070424212956.GE16457@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424212956.GE16457@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 11:29:56PM +0200, Pavel Machek wrote:
> We do not want to fragment the testing base, and suspend2 does not
> really have any interesting features over uswsusp.

The testing base is already fragmented!

What the current situation means is that you simply never hear from
the people who get fed up with suspend but who manage to get suspend2
working.

-- 
Mathematics is the supreme nostalgia of our time.
