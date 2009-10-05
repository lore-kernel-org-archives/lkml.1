Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZJEUzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZJEUzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbZJEUzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:55:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbZJEUzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:55:40 -0400
Date: Mon, 5 Oct 2009 13:54:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86: Generate cmpxchg build failures
In-Reply-To: <1254771187.21044.22.camel@laptop>
Message-ID: <alpine.LFD.2.01.0910051353490.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>  <4AC060AE.1090401@gmail.com>  <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>  <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>  <4AC10365.7090802@gmail.com>
 <4AC2712C.4080901@gmail.com>  <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>  <1254758425.26976.126.camel@twins>  <alpine.LFD.2.01.0910051210280.3432@localhost.localdomain> <1254771187.21044.22.camel@laptop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Oct 2009, Peter Zijlstra wrote:
> 
> Here's a new one, still seems to build i386 and x86_64 defconfigs.

Ack. Looks good to me.

		Linus
