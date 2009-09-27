Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172AbZI0Xw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbZI0Xw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 19:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZI0Xw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 19:52:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbZI0Xw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 19:52:57 -0400
Date: Sun, 27 Sep 2009 16:52:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc1
In-Reply-To: <20090928094458.4ad704c2.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.01.0909271650480.3349@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <20090928094458.4ad704c2.sfr@canb.auug.org.au>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Sep 2009, Stephen Rothwell wrote:

> Hi Linus,
> 
> On Sun, 27 Sep 2009 15:34:53 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > It's been two weeks (and then some - but with last week being LinuxCon and 
> > Plumbers conf I extended it by a few days), and as usual that means that 
> > the merge window is all over and done with. 2.6.32-rc1 is out, so give it 
> > a whirl.
> 
> Of course, you realise that you set EXTRAVERSION to -rc2  :-(

Oh nnooooooooooooo-(takes breath)-ooooooo...

Damn. I hadn't realized. I'm a moron.

Ok, so it's an extra-special -rc1. It's the "short bus" kind of special 
-rc1 release. But quite frankly, I'll just let it be. The git tags etc 
look to be ok, it's just my editing of the Makefile itself that was too 
complicated for my little mind.

I'll try not to do that again,

		Linus
