Return-Path: <linux-kernel-owner+w=401wt.eu-S933362AbZLKBey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362AbZLKBey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbZLKBev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:34:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37718 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346AbZLKBeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:34:44 -0500
Date: Thu, 10 Dec 2009 20:34:49 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "C. Bergstr?m" <cbergstrom@pathscale.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm
Message-ID: <20091211013449.GC28962@bombadil.infradead.org>
References: <1260459601.18520.26.camel@skunk> <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain> <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com> <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain> <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com> <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain> <20091210235835.20e2269d@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain> <4B219046.3080908@pathscale.com> <alpine.LFD.2.00.0912101623010.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912101623010.3560@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 04:32:56PM -0800, Linus Torvalds wrote:
> > "patches welcome"
> 
> The problem is that I have never even heard a Red Hat or Fedora person 
> actually acknoledge that yes, they should be trying to upstream it.
> 
> Have Red Hat and Fedora just decided that "upstream first" simply doesn't 
> matter any more? Because quite frankly, that was kind of the feeling I 
> came away with from the Kernel summit.
> 

Well, given that none of the Fedora kernel people were able to attend
this year for a variety of reasons, this is an interesting revelation to
me, I wasn't aware I thought this.

I, for one, would very much like nouveau to be upstream. It would
certainly make my life easier not having to worry about subtlely
breaking graphics adapters I can't test whenever we rebase to new git
changes in the DRM. Thankfully Ben and Dave have been ninja at dealing
with it, otherwise I probably would have punted it by now.

> It's like they _want_ to keep it internal.
>

regards, Kyle

