Return-Path: <linux-kernel-owner+w=401wt.eu-S936953AbXHOXUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936953AbXHOXUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbXHOXUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:20:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52776 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbXHOXUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:20:03 -0400
Date: Thu, 16 Aug 2007 00:19:49 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, Rene Herman <rene.herman@gmail.com>,
       git@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
Message-ID: <20070815231949.GM21089@ftp.linux.org.uk>
References: <1187054366.2757.0.camel@laptopd505.fenrus.org> <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu> <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost> <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost> <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org> <20070814193333.GI21089@ftp.linux.org.uk> <m3fy2kk2ra.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3fy2kk2ra.fsf@maximus.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 09:37:45PM +0200, Krzysztof Halasa wrote:
> > I'm not suggesting something like fs.ext2@kernel.org with something
> > like majordomo allowing to add yourself to those,
> 
> Why not

You'd need to implement serious anti-spam measures for that.  Besides,
cross-postings between random sets of lists would become a nightmare
pretty soon.
