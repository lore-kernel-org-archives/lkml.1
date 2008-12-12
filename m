Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbYLLFlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbYLLFlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbYLLFlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:41:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbYLLFlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:41:45 -0500
Date: Thu, 11 Dec 2008 21:40:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.28-rc8
In-Reply-To: <20081211.191949.05090709.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0812112138510.3340@localhost.localdomain>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <24401.1229009346@redhat.com> <20081211.191949.05090709.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Dec 2008, David Miller wrote:

> From: David Howells <dhowells@redhat.com>
> Date: Thu, 11 Dec 2008 15:29:06 +0000
> 
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > >  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> > > 
> > >      I like this, because alledgely people are debugging things, and we'd 
> > >      get a more stable 2.6.28.
> > 
> > Which would perhaps mean that the merge window is open during LCA, which will
> > be inconvenient for some people.  On the other hand, it might put the culprits
> > where you can lay your hands on them.
> 
> That happened in Melbourne and it wasn't pleasant.  Instead
> of enjoying talks at the conference some of us were stressing
> out on our laptops dealing with our merges instead.

Yes. I definitely want to close the 29 merge window before LCA. In fact, I 
want to close it far enough before that we can fix up any worst issues.

Which does argue for opening it up during the holidays, I guess. 

		Linus
