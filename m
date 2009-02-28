Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZB1Ac3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZB1Ac3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 19:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZB1AcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 19:32:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614AbZB1AcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 19:32:20 -0500
Date: Fri, 27 Feb 2009 16:30:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
 3 users
In-Reply-To: <alpine.DEB.2.00.0902270955100.25593@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0902271630230.3111@localhost.localdomain>
References: <49a38304.0506d00a.1f4b.406d@mx.google.com> <20090226130243.GA22460@elte.hu> <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere>
 <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu> <20090227061936.GA5318@nowhere> <20090226224656.5785de9e.akpm@linux-foundation.org> <alpine.DEB.2.00.0902270955100.25593@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Feb 2009, Steven Rostedt wrote:
> 
> HAHAHAHHAAAA!!!! My evil scheme is working! I post some sub-optimal code, 
> and have others do the nasty work for me!!!!
> 
> Oh, did I just say that out loud?

Not only that, I will also sue you for my patent on that algorithm.

			Linus
