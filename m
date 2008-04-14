Return-Path: <linux-kernel-owner+w=401wt.eu-S1761119AbYDNWko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761119AbYDNWko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYDNWkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:40:35 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:54708 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbYDNWke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:40:34 -0400
Date: Tue, 15 Apr 2008 02:32:31 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       dwmw2@infradead.org, miklos@szeredi.hu, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080414223230.GA32389@2ka.mipt.ru>
References: <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <20080413154459.4b2f125d.akpm@linux-foundation.org> <20080413234920.63711ca7@core> <20080413161014.cb06964c.akpm@linux-foundation.org> <20080414091639.4bd3879d@core> <20080414084141.GA29113@infradead.org> <4803C4A8.7020304@garzik.org> <20080414141139.10d4d4c0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414141139.10d4d4c0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Apr 14, 2008 at 02:11:39PM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> A new filesystem such as the one he's working on would, one hopes, be used
> by an increasing number of people.  Whereas I expect that the already-tiny
> number of people who use OMFS will *fall* over time.

It is not about pohmelfs, but any other. When did you look at fs/kconfig
last time? There are lots of filesystems which were obsoleted way before
I first time started using computer. Hope you saw with pdp-11 in action
(I only on pictures), since sysv filesystem is very unlikely to get new
users today. Or befs - beos is very widely distributed os. Others?
 
> Guys, a few years ago Linus's rule of thumb for merging an FS was,
> approximately, "it is already being shipped by distros".  The bar is _much_
> lower than that now.  Largely because I personally think that it should be.

And Linus was wrong. This can not happen? He can not change his opinion?
Btw, which distro shipped ext4 before it was included (splitted) into
mainline?

Just say no to double standards!

P.S. Added Linus to copy list, hope it will be interesting...

-- 
	Evgeniy Polyakov
