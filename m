Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZDPAnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZDPAnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZDPAnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:43:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbZDPAnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:43:20 -0400
Date: Wed, 15 Apr 2009 17:38:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <alpine.LFD.2.00.0904151717040.4042@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904151736140.4042@localhost.localdomain>
References: <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain>
 <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain> <20090415224017.GA18764@elte.hu> <alpine.LFD.2.00.0904151607010.4042@localhost.localdomain> <20090416000841.GA18185@elte.hu>
 <alpine.LFD.2.00.0904151717040.4042@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, Linus Torvalds wrote:
> 
> wouldn't you agree? Adding a "Impact: cleanup" wouldn't do anything to it, 
> except make it not read as good English any more.
> 
> I like seeing explanations that read well. 

Btw, I suspect that if the "Impact:" line is at the end, along with the 
"Signed-off-by:" etc lines, it wouldn't be as disturbing and I wouldn't 
react as negatively to it.

At least then it wouldn't break up the narrative, and it would kind of fit 
with all the other "tagged" lines.

			Linus
