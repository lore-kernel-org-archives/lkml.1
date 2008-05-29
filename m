Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYE2QdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYE2QdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbYE2QdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:33:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50628 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbYE2QdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:33:04 -0400
Date: Thu, 29 May 2008 10:32:47 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jiri Kosina <jkosina@suse.cz>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org, penberg@cs.helsinki.fi,
       dwmw2@infradead.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080529163247.GW22636@parisc-linux.org>
References: <1212010931.3445.103.camel@localhost.localdomain> <1212013125.2236.58.camel@shinybook.infradead.org> <1212014127.3445.115.camel@localhost.localdomain> <20080528.230934.131215087.davem@davemloft.net> <1212071813.3428.22.camel@localhost.localdomain> <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 05:06:15PM +0200, Jiri Kosina wrote:
> I fully agree, but my impression is that this really is not going to be 
> easy. Fixing bugs definitely is a good way to start kernel coding -- it 
> forces you to understand the internals of the source, get used to the 
> coding style by reading the code, etc. Unfortunately, it's simply not very 
> attractive for newcomers.

"Programming is hard, let's go shopping"?

> For example -- I am leading a seminar at university, oriented at linux 
> kernel internals. I provide the possibility to students either to
> 
> - write some stand-alone interesting kernel project
> - fix a few non-trivial bugs in kernel bugzilla
> - chose any part of a kernel, learn how it works, and present this to 
>   other seminar attendees
> 
> The feedback I often get from students (and these guys are studying 
> computer science) is
> 
> - writing some wholy new interesting kernel project is usually too 
>   complicated (both coming with an interesting idea for a project, and 
>   doing the coding itself)
> - fixing random bugs from kernel bugzilla is boring (spending 10 hours 
>   looking for missing '=' doesn't really attract them)
> 
> So in overwhelming majority of cases, they just chose the presentation.

In general, students are going to choose the easiest option ;-)

Perhaps you could try making the process of finding a kernel bug seem
more exciting?  I doubt that most kernel bugs are a simple as a missing =.
But even if they were, it's about the /process/ you take to get to that
boring patch.

> All I want to say is that I could very well imagine that a lot of 
> newcomers will find "hey, feel free to crawl through bugzilla and fix 
> whatever you are able to fix" very non-attractive.

Of course.  We have to make it sexier than that.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
