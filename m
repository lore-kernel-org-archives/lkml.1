Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbZFPVUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbZFPVUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZFPVUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:20:25 -0400
Received: from kroah.org ([198.145.64.141]:38173 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbZFPVUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:20:25 -0400
Date: Tue, 16 Jun 2009 14:03:09 -0700
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ryan Hope <rmh3093@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm - fixes + radeon KMS (part 2)
Message-ID: <20090616210309.GA3563@kroah.com>
References: <alpine.DEB.2.00.0906150302250.20307@skynet.skynet.ie> <20090615022235.GA12905@kroah.com> <21d7e9970906141943s8dd6e27sd4308413601d65e3@mail.gmail.com> <48f7fe350906160853m41f43fe5i892a4057b5eae319@mail.gmail.com> <alpine.LFD.2.01.0906161119500.3282@localhost.localdomain> <21d7e9970906161345q6e826d18q3a197643e370156c@mail.gmail.com> <alpine.LFD.2.01.0906161351130.16802@localhost.localdomain> <21d7e9970906161356y75702185gff0500571fff1e47@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970906161356y75702185gff0500571fff1e47@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 06:56:31AM +1000, Dave Airlie wrote:
> On Wed, Jun 17, 2009 at 6:52 AM, Linus
> Torvalds<torvalds@linux-foundation.org> wrote:
> >
> >
> > On Wed, 17 Jun 2009, Dave Airlie wrote:
> >>
> >> Linus can you pull this tree?
> >
> > I hate pulling trees when I know there are _known_ bugs.
> >
> > Even during the merge window. The rest of the -rc series is for fixing up
> > bugs, yes, but not bugs that were introduced on purpose.
> >
> 
> It only happens if the user enable staging drivers, and I suspect staging
> has much worse bugs, but okay I'll put the initcall fix into the tree
> and send you another pull request.

Note, distros enable the staging tree to pick up drivers they were
previously including anyway.  So that is quite a large userbase :)

thanks,

greg k-h
