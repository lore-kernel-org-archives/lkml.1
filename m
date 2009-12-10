Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbZLJXhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbZLJXhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbZLJXht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:37:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757343AbZLJXhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:37:48 -0500
Date: Thu, 10 Dec 2009 15:37:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephane Marchesin <stephane.marchesin@gmail.com>
cc: Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
In-Reply-To: <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>  <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>  <1260459601.18520.26.camel@skunk>  <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>  <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
  <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain> <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Dec 2009, Stephane Marchesin wrote:
> 
> I'm not sure why people are arguing so much over this, given that no
> nouveau devs were at the kernel summit, and we only heard rumours
> afterwards that there were complaints about us not being ready for
> merging.

The thing is, my complaint is not about whatever external driver project.

We have those all the time. I'm not complaining about Nouveau people.

I'm pissed off at distribution people. For years now, distributions have 
talked about "upstream first", because of the disaster and fragmentation 
that was Linux-2.4. And most of them do it, and have been fairly good 
about it.

But not only is Fedora not following the rules, I know that Fedora people 
are actively making excuses about not following the rules. I know Red Hat 
actually employs (full-time or part-time I have no idea) some Nouveau 
dveloper, and by that point Red Hat should also man up and admit that they 
need to make "merge upstream" be a priority for them.

See? I'm not complaining about _you_. I'm complaining about Fedora and Red 
Hat.

> If you have issues to raise about nouveau, please raise them on the
> nouveau, mesa or dri lists, at least some time before starting to
> complain. I must say I didn't think such a big issue was going on
> here, that's the problem with rumours.

See above. It's not you. It's Fedora. If Fedora hadn't merged Nouveau and 
shipped it, I wouldn't care.

Or rather, I probably still -would- care, but I would care because nVidia 
hardware is common, and I like open source drivers. But I wouldn't be 
disappointed and pissed off.

And this has been going on for a _loong_ time now. Fedora has been 
shipping Nouveau for about a year now, I think.

			Linus
