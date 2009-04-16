Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZDPC11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZDPC11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZDPC1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:27:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879AbZDPC1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:27:10 -0400
Date: Wed, 15 Apr 2009 19:22:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <20090416014642.GA24029@elte.hu>
Message-ID: <alpine.LFD.2.00.0904151918370.4042@localhost.localdomain>
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415.142326.97287514.davem@davemloft.net> <20090415224800.GA22425@elte.hu>
 <alpine.LFD.2.00.0904151608470.4042@localhost.localdomain> <20090416004430.GA22616@elte.hu> <alpine.LFD.2.00.0904151757100.4042@localhost.localdomain> <20090416014642.GA24029@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Ingo Molnar wrote:
> 
> Show me one person _you_ actually taught to write good changelogs - 
> just one person who was not a natural born talker to begin with. 
> I'll show you a 100 other people who cannot write good commit logs. 
> They'll try and will limp along, but generally they cannot.
> 
> They might not even have English as their mother tongue - but still 
> can read and understand C fantastically.

So?

The fix for that is not to write crap English. The fix for that is to help 
them, and/or just fix their comments for them.

I really don't see the point of your argument. "People don't always write 
good and complete sentences" is _not_ an argument for then making that a 
standard. 

Just fix things up. Edit their emails. I do. Andrew does. Yes, and despite 
that some commits will still have odd grammar or otherwise not be the 
great novel of the century, and that's not the point. But we should 
_improve_ on the language for people who aren't native English speakers, 
not devolve it to something weaker.

			Linus
