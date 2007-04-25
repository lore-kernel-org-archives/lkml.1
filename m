Return-Path: <linux-kernel-owner+w=401wt.eu-S1422968AbXDYXd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422968AbXDYXd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422973AbXDYXd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:33:58 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1918 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422968AbXDYXd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:33:56 -0400
Date: Thu, 26 Apr 2007 01:33:55 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425233355.GA36476@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Bunk <bunk@stusta.de>, Pavel Machek <pavel@ucw.cz>,
	Ingo Molnar <mingo@elte.hu>,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
	Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
	Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arjan van de Ven <arjan@infradead.org>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de> <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de> <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 11:50:45AM -0700, Linus Torvalds wrote:
> .. but if the alternative is a feature that just isn't worth it, and 
> likely to not only have its own bugs, but cause bugs elsewhere? (And yes, 
> I believe STD is both of those. There's a reason it's called "STD". Go 
> to google and type "STD" and press "I'm feeling lucky". Google is God).

If it was correctly designed, it would be possible to change the
hardware or even the kernel through a STD cycle.  And that would be
damn interesting on servers.

In any case, if I could trust it, I'd use it when I need to move
servers around and I don't want to lose what is running.  Riding power
cuts that way would be nice.

  OG.

