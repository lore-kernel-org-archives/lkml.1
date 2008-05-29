Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbYE2PGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbYE2PGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYE2PGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:06:18 -0400
Received: from styx.suse.cz ([82.119.242.94]:58314 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753290AbYE2PGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:06:17 -0400
Date: Thu, 29 May 2008 17:06:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: David Miller <davem@davemloft.net>,
       ksummit-2008-discuss@lists.linux-foundation.org, penberg@cs.helsinki.fi,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
In-Reply-To: <1212071813.3428.22.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz>
References: <1212010931.3445.103.camel@localhost.localdomain>
 <1212013125.2236.58.camel@shinybook.infradead.org>
 <1212014127.3445.115.camel@localhost.localdomain> <20080528.230934.131215087.davem@davemloft.net>
 <1212071813.3428.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, James Bottomley wrote:

> Really, I think that's what our mistake is in the recruitment program 
> is: we need to start people out on useful tasks that they can do rather 
> than on tasks we find annoying and useless in the hope they move on to 
> something better.

I fully agree, but my impression is that this really is not going to be 
easy. Fixing bugs definitely is a good way to start kernel coding -- it 
forces you to understand the internals of the source, get used to the 
coding style by reading the code, etc. Unfortunately, it's simply not very 
attractive for newcomers.

For example -- I am leading a seminar at university, oriented at linux 
kernel internals. I provide the possibility to students either to

- write some stand-alone interesting kernel project
- fix a few non-trivial bugs in kernel bugzilla
- chose any part of a kernel, learn how it works, and present this to 
  other seminar attendees

The feedback I often get from students (and these guys are studying 
computer science) is

- writing some wholy new interesting kernel project is usually too 
  complicated (both coming with an interesting idea for a project, and 
  doing the coding itself)
- fixing random bugs from kernel bugzilla is boring (spending 10 hours 
  looking for missing '=' doesn't really attract them)

So in overwhelming majority of cases, they just chose the presentation.


All I want to say is that I could very well imagine that a lot of 
newcomers will find "hey, feel free to crawl through bugzilla and fix 
whatever you are able to fix" very non-attractive.
Not that I have any better idea right now, though.

-- 
Jiri Kosina
SUSE Labs
