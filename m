Return-Path: <linux-kernel-owner+w=401wt.eu-S1762845AbYFFCnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845AbYFFCnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYFFCmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:42:51 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58861 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbYFFCmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:42:50 -0400
X-Sasl-enc: yyUQkBoM+rZ4qKuBBawyuSoVE3mZ82Kc19+XZpXsFnC2 1212720165
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806051427310.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
	 <20080603095713.GR28946@ZenIV.linux.org.uk>
	 <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212651099.3047.44.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806051427310.3473@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:39:12 +0800
Message-Id: <1212719953.3035.3.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 14:29 -0700, Linus Torvalds wrote:
> 
> On Thu, 5 Jun 2008, Ian Kent wrote:
> > 
> > Keep in mind this doesn't address any other autofs4 issues but I it
> > should allow us to identify if this was in fact the root cause of the
> > problem Jesper reported.
> 
> Jesper, can you test this? I think you said you could trigger this in ~24 
> hours or so? I'd love to have some testing of some heavy autofs user. Even 
> if it's not a guarantee of a fix (due to reproducing the bug not being 
> entirely trivial), at least I'd like to know that it doesn't introduce any 
> obvious new problems either..

I'm continuing to test this also.
My initial testing was fine but late last night, with some of my other
patches applied as well, I started seeing some strange problems.

Ian


