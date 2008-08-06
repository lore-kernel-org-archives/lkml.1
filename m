Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYHFNcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYHFNcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757183AbYHFNcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:32:36 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4365 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522AbYHFNce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:32:34 -0400
Date: Wed, 6 Aug 2008 09:15:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT]: Networking
Message-ID: <20080806131503.GD7036@tuxdriver.com>
References: <20080805.190020.244441681.davem@davemloft.net> <A0AAD67C-1F54-4D85-A413-91BBBE044452@holtmann.org> <alpine.LFD.1.10.0808052308080.15995@nehalem.linux-foundation.org> <200808061022.02432.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808061022.02432.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 10:22:02AM +0200, Ivo van Doorn wrote:
> On Wednesday 06 August 2008, Linus Torvalds wrote:

> > Well, it's also trying to support both 2.4.x and 2.6 etc. Yeah, that is 
> > horrid. At the same time, I can't say that the "rewrite it entirely" 
> > approach of the previous-gen cards has worked very well either, since that 
> > seems to have just perpetuated the problems. It would be great to try to 
> > educate them, but I'm not finding even an email address in the sources.
> 
> I've send a mail to Ralink with a request if they could step away from the
> "port the windows driver to linux" idea and get the Linux driver "kernel-ready"
> early on.
> That won't solve the problem now, but hopefully it does mean the drivers for
> the next generation can go into the kernel sooner.

The Ralink guys are being educated and AFAICT they are interested in
better participation.  Time will tell, of course.

In the meantime as Ivo indicated he is "on the case" -- I think we
will see something before too long.

John
-- 
John W. Linville
linville@tuxdriver.com
