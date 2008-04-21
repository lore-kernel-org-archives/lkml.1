Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYDUXaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYDUXaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYDUXao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:30:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001AbYDUXan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:30:43 -0400
Date: Mon, 21 Apr 2008 16:29:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Please pull the (new) Trivial tree
In-Reply-To: <9a8748490804211621s7e19394bn6911d8d093fcb8dc@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0804211626230.2779@woody.linux-foundation.org>
References: <9a8748490804211615y25329beapf019d3c2907defe6@mail.gmail.com> <9a8748490804211621s7e19394bn6911d8d093fcb8dc@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Jesper Juhl wrote:
> >
> >  Please pull git://git.kernel.org/pub/scm/linux/kernel/git/juhl/trivial.git
> >  for-linus

Please format this differently. I want to use cut-and-paste rather than 
re-typing random letter combinations that people use, so please write this 
as

   Please pull branch 'for-linus' of my trivial tree from

	git://git.kernel.org/pub/scm/linux/kernel/git/juhl/trivial.git for-linus

   to get these changes:
	...

where the important part is that I want the git repo address _and_ the 
branch on one line, all by themselves. That way I don't have to pick 
things up, I can just cut-and-paste the whole line (triple-click) without 
worrying about boundaries or finding branch names somewhere else.

> I guess one thing I should remember to do is include the git-shortlog
> of the changes I'm asking you to pull ;-)

Also, git diffstat output, ie the output from a command something like:

	git diff --stat --summary -M origin...

In fact, I think "git request-pull" will basically generate all of this.

		Linus
