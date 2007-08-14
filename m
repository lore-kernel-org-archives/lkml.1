Return-Path: <linux-kernel-owner+w=401wt.eu-S934688AbXHNT5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934688AbXHNT5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758486AbXHNT5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:57:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4882 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbXHNT5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:57:37 -0400
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>, git@vger.kernel.org,
       Junio C Hamano <gitster@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070814193333.GI21089@ftp.linux.org.uk>
References: <1187026955.2688.4.camel@laptopd505.fenrus.org>
	 <1187037445.6628.98.camel@heimdal.trondhjem.org>
	 <1187054366.2757.0.camel@laptopd505.fenrus.org>
	 <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu>
	 <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost>
	 <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost>
	 <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
	 <20070814193333.GI21089@ftp.linux.org.uk>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 12:57:15 -0700
Message-Id: <1187121435.32555.166.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 20:33 +0100, Al Viro wrote:
> FWIW, I suspect that we are looking at that from the wrong POV.  If
> that's about "who ought to be Cc'd on the issues dealing with <list
> of pathnames>", why does it have to be tied to "who is maintainer for
> <pathname>"?

Right, it doesn't have to.
I think a notification list would be just fine.

> I'm not suggesting something like fs.ext2@kernel.org with something
> like majordomo allowing to add yourself to those, but something less
> extreme in that direction might be worth thinking about...
> Hell, even simple
> $ finger fs/minix/dir.c@cc.kernel.org
> with majordomo-like interface for adding yourself to such lists
> might solve most of those problems...

Might solve all of my wants for this problem.

cheers, Joe

