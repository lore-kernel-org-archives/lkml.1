Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbZDOXRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbZDOXRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZDOXQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:16:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbZDOXQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:16:56 -0400
Date: Wed, 15 Apr 2009 16:11:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <20090415224800.GA22425@elte.hu>
Message-ID: <alpine.LFD.2.00.0904151608470.4042@localhost.localdomain>
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415.142326.97287514.davem@davemloft.net> <20090415224800.GA22425@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Ingo Molnar wrote:
> 
> So do you consider it wrong to summarize impact?

No.

NOBODY is arguing against talking about what the thing does.

We're arguing against the string "Impact:", which is nonsensical.

> Does this argument extend to other summaries as well, such as the title 
> itself?

Umm. The summary line that doesn't have such a made-up nonsensical prefix?

Ingo, you're missing the _point_.

Summaries and good description of patches are GOOD.

The "Impact:" string is just noise.

Talk about how it was a cleanup all you want, and by all means talk about 
what the intention of it was. Nobody argues against that. What we argue 
against is ugly language. 

Describe the changes in real sentences.

		Linus
