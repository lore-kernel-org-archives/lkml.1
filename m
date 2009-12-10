Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbZLJSn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbZLJSn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761444AbZLJSn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:43:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761436AbZLJSn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:43:26 -0500
Date: Thu, 10 Dec 2009 10:42:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Maarten Maathuis <madman2003@gmail.com>
cc: Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
In-Reply-To: <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>  <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>  <1260459601.18520.26.camel@skunk>  <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
 <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Dec 2009, Maarten Maathuis wrote:
> 
> You assume that Red Hat has full control over the project, which i
> don't think is the case. The reason it isn't in staging yet (as far as
> i know) is because of some questions over the copyright of some
> (essential) microcode. Either the question needs to be answered, or it
> has to be reverse engineered to the point that it's possible to
> generate it.

I think people are just making up excuses, as evidenced by the fact that 
you're quoting a different excuse than I've heard before.

The fact is, if there are license questions, then Fedora had better not be 
distributing the code either. And they clearly are.

And don't tell me about "full control". There's absolutely full control 
over it being included or not. 

When I brought this up at the kernel summit, there were various other 
random excuses. I think one of them was that it wasn't part of an official 
Fedora release (which is sure as hell not true at least as of Fedora 12). 

I've heard the "but it's hard to merge" excuse too - which I also know is 
bullshit, because I can look at the git tree Fedora apparently uses, and 
it merges without any conflicts what-so-ever.

The most common excuse is the "oh, but it might change" crap. But that's 
not even a very good excuse to start with, and it's what staging is for 
anyway.

Somebody even made the crazy comment that "but Fedora isn't a real 
distribution, so it doesn't need to follow the rules everybody agreed to 
several _years_ ago wrt merging stuff to mainline".

I _think_ that last one was meant as a joke. But it's damn hard to tell, 
because the ones that are apparently sincere are equally crazy. People 
just seem to make up total crap to make excuses for something that 
everybody knows is wrong.

			Linus
