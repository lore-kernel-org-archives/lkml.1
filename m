Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030924Ab0B0XjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 18:39:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030902Ab0B0XjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 18:39:00 -0500
Date: Sat, 27 Feb 2010 15:38:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Eric Paris <eparis@redhat.com>, viro@zeniv.linux.org.uk, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] notification: including fanotify
In-Reply-To: <20100228102937.cac7dc55.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.1002271531520.4513@localhost.localdomain>
References: <1267218869.10582.12.camel@localhost> <alpine.LFD.2.00.1002271323320.4513@localhost.localdomain> <alpine.LFD.2.00.1002271331570.4513@localhost.localdomain> <20100228102937.cac7dc55.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Feb 2010, Stephen Rothwell wrote:
> 
> You also forgot to mention that this whole tree has been rebased since
> (my) Friday and the version of the above commit in linux-next does not
> have that hunk.

Yeah. This is why I hate people who rebase too much. 

I don't mind rebases per se, but when they happen within the last few 
days, it just tells me that "that tree got no testing". 

So guys: feel free to rebase. But when you do, wait a week afterwards. 
Don't "rebase and ask Linus to pull". That's just _wrong_. It means that 
the tree you asked me to pull has gotten zero testing.

And sometimes that lack of testing is more obvious than other times. In 
this case, it was pretty damn obvious.

				Linus
