Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbXLFUWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbXLFUWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXLFUWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:22:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:36183 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751983AbXLFUWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:22:22 -0500
X-Authenticated: #1490710
X-Provags-ID: V01U2FsdGVkX1+cyhoPC9ec6nuRUbjMWVClQSSTI5NHK27IfebMnJ
	X9itHd8JzOmRnt
Date: Thu, 6 Dec 2007 21:22:18 +0100 (CET)
From: Johannes Schindelin <Johannes.Schindelin@gmx.de>
X-X-Sender: gene099@wbgn129.biozentrum.uni-wuerzburg.de
To: Al Boldi <a1426z@gawab.com>
cc: Andreas Ericsson <ae@op5.se>, Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: git guidance
In-Reply-To: <200712072155.04643.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0712062119090.21625@wbgn129.biozentrum.uni-wuerzburg.de>
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com>
 <200712072035.47359.a1426z@gawab.com> <47583E57.9050208@op5.se>
 <200712072155.04643.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 7 Dec 2007, Al Boldi wrote:

> Andreas Ericsson wrote:
> > Al Boldi wrote:
> >
> > > By pulling the sources into a git-client manager mounted on some 
> > > dir, it should be possible to let the developer work 
> > > naturally/transparently in a readable/writeable manner, and only 
> > > require his input when reverting locally or committing to the 
> > > server/repository.
> >
> > How is that different from what every SCM, including git, is doing 
> > today? The user needs to tell the scm when it's time to take a 
> > snapshot of the current state. Git is distributed though, so 
> > committing is usually not the same as publishing. Is that lack of a 
> > single command to commit and publish what's nagging you? If it's not, 
> > I completely fail to see what you're getting at, unless you've only 
> > ever looked at repositories without a worktree attached, or you think 
> > that git should work like an editor's "undo" functionality, which 
> > would be quite insane.
> 
> You need to re-read the thread.

I don't know why you write that, and then say thanks.  Clearly, what you 
wrote originally, and what Andreas pointed out, were quite obvious 
indicators that git already does what you suggest.

You _do_ work "transparently" (whatever you understand by that overused 
term) in the working directory, unimpeded by git.

And whenever it is time to revert or commit, you cry for help, invoking 
git.

So either you succeeded in making yourself misunderstood, or Andreas had 
quite the obvious and correct comment for you.

Not that diffcult,
Dscho

