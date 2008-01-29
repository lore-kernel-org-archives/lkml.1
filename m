Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYA2Llo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYA2Llo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYA2Llg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:41:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbYA2Llf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:41:35 -0500
Date: Tue, 29 Jan 2008 22:41:24 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Matthew Wilcox <matthew@wil.cx>
cc: linux-kernel@vger.kernel.org, Liam Howlett <howlett@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Pull request: TASK_KILLABLE
In-Reply-To: <20080129000447.GC31101@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0801292237480.3505@www.l.google.com>
References: <20080129000447.GC31101@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jan 2008, Matthew Wilcox wrote:
> 
> I'd like you to pull the task_killable branch of 
> git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git

Well, Andrew already pointed out some of this, but I do want more 
information. There's a "git request-pull" script that even comes with git 
and that generates a shortlog, a proper url+branch description, and a 
diffstat of the changes.

So that is already much more descriptive, but in addition to that, if this 
isn't one of the "regular" pulls (which it obviously isn't), I really want 
a human description too so that I know what I'm pulling and what it's all 
about.

I do *not* want to be in the position of having to fetch first, just to be 
able to look at what I'm fetching. By the time I pull a branch, I want to 
basically know (a) what I'm pulling and (b) why I _want_ to pull it.

		Linus
