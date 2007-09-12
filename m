Return-Path: <linux-kernel-owner+w=401wt.eu-S971651AbXILSOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971651AbXILSOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXILSOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:14:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46902 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXILSOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:14:15 -0400
Date: Wed, 12 Sep 2007 20:14:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: x86 merge - a little feedback
In-Reply-To: <alpine.LFD.0.999.0709111448520.16478@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709122013230.22467@fbirervta.pbzchgretzou.qr>
References: <20070911201219.GA9674@uranus.ravnborg.org> <200709112138.11247.ak@suse.de>
 <20070911211422.GU3563@stusta.de> <200709112234.24155.ak@suse.de>
 <alpine.LFD.0.999.0709111448520.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 11 2007 14:51, Linus Torvalds wrote:
>On Tue, 11 Sep 2007, Andi Kleen wrote:
>> 
>> Will that cause people to compile test both? I have my doubts that 
>> will really work.
>
>If people don't compile-test both now, then why would they compile-test 
>things when merged?
>
>So no, that's not the point.
>
>But at least things like "grep" will work sanely, and people will be 
>*aware* that "Oh, this touches a file that may be used by the other 
>word-size".

Speaking of which, how does sparc/sparc64 handle things?




	Jan
-- 
