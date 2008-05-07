Return-Path: <linux-kernel-owner+w=401wt.eu-S934099AbYEGW7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbYEGW7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764433AbYEGW7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:59:11 -0400
Received: from www.tglx.de ([62.245.132.106]:60956 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765463AbYEGW7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:59:08 -0400
Date: Thu, 8 May 2008 00:58:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@suse.cz>
cc: Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: 2.6.26, PAT and AMD family 6
In-Reply-To: <20080507221435.GH18516@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0805080032400.3318@apollo.tec.linutronix.de>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <20080507212343.GB14951@cs181133002.pp.htv.fi>
 <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de> <20080507221435.GH18516@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Pavel Machek wrote:
>
> Actually no, that's not a good reason to yell at _him_.

I'm glad, that we can agree on this.

> But it is _perfectly valid_ reason to yell at whoever commited that
> to x86 tree, given that:
>
> 1) it has empty changelog (come on, "review" a patch and not notice
> that changelog is empty?!) 

Granted as I said before.

> 2) HPA said it was bad idea

Interpretation.

> 3) copy&paste code remained in the patch 

Yes, it should have been done better.

So we made mistakes, but is this a justification for magnifying that
to be the major contribution to the end of the universe ?

Definitely not.

I have no problem to admit a mistake, but I vehemently fight the way
how such incidents are artificially exxagerated in the recent past.

I personally have broad enough shoulders to cope with the fact that
bashing on x86 maintainers and trying to play them out against each
other is currently en vogue.

But I have no understanding at all for the snotty way how valuable
contributors are treated even when the responsibility of the actual
merging of their imperfect patch is out of their scope.

Thanks,

	tglx
