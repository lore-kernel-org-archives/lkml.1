Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbXEIMyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbXEIMyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbXEIMy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:54:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3737 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755103AbXEIMy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:54:28 -0400
Date: Wed, 9 May 2007 12:54:16 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
Message-ID: <20070509125415.GA4720@ucw.cz>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084623.GB14364@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501084623.GB14364@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
> 
> ...
> 
> > Dominik is busy.  Will probably re-review and send these direct to Linus.
> 
> The patch above is the removal of cardmgr support.  While I'd love to
> see this cruft gone it definitively needs maintainer judgement on whether
> they time has come that no one relies on cardmgr anymore.

I remember needing cardmgr few months ago on sa-1100 arm system. I'm
not sure this is obsolete-enough to kill.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
