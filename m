Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZDOXMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZDOXMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZDOXMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:12:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbZDOXMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:12:44 -0400
Date: Wed, 15 Apr 2009 16:08:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <20090415224017.GA18764@elte.hu>
Message-ID: <alpine.LFD.2.00.0904151607010.4042@localhost.localdomain>
References: <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com>
 <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain> <20090415224017.GA18764@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Ingo Molnar wrote:
>
> As i said it in the mail, i actually used the impact line of commit 
> 6b44003e5ca66 ("work_on_cpu(): rewrite it to create a kernel thread 
> on demand") later on, when a regression was caused by that commit.

Duh. You keep on repeating that idiotic argument.

The "Impact:" part had nothing what-so-ever to do with what you argue for.

I'm not arguing against good commit messages. I'm arguing against the 
"Impact:" part. It's pointless.

ALL of the commit message is (hopefully) about important things. If you 
want to narrow it down to one single line, that's just WRONG.

		Linus
