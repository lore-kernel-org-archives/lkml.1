Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbYDZRWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbYDZRWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbYDZRW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:22:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758618AbYDZRWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:22:25 -0400
Date: Sat, 26 Apr 2008 10:21:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Adrian Bunk <bunk@stusta.de>, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
In-Reply-To: <20080426170950.GL2252@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804261016050.2813@woody.linux-foundation.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426112717.GA23248@uranus.ravnborg.org> <20080426144404.GG2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804260951190.2813@woody.linux-foundation.org>
 <20080426170950.GL2252@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Adrian Bunk wrote:
> 
> The patch for the x86 userspace header breakage last weekend was Cc'ed 
> to you.

Yes, and I couldn't care less - it wasn't critical in any way (nobody 
should be using kernel headers directly in user space anyway, so the only 
people who could _possibly_ care were the people who build glibc releases 
etc).

IOW, it wasn't a critical bug-fix that needed to be pushed out 
aggressively.

Which means that I totally ignore a patch when I see that there are people 
who actually maintain that area (especially if I know they are responsible 
maintainers) that are also cc'd and that even reply to it.

It so happens that that patch got merged into my tree today - unrelated to 
this discussion - and it came through all the normal channels (ie the x86 
maintainer tree).

IOW, everything happened exactly the way it is SUPPOSED to happen.

That said, it also obviously does happen that I lose patches for real. 
Maybe some of them even from you. But your complaints really aren't 
sensible in this case.

			Linus
