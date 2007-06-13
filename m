Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbXFMUPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbXFMUPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbXFMUPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:15:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2825 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751685AbXFMUPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:15:41 -0400
Date: Wed, 13 Jun 2007 14:18:18 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: Matthias Schniedermeyer <ms@citd.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
Message-ID: <20070613141818.GF5986@ucw.cz>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de> <466C3B64.4070806@citd.de> <20070611060759.GB914@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611060759.GB914@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Yes, but this file, and the stable-api-nonsense.txt files are there to
> help people understand both the kernel's philosophy, as well as
> encourage them to help contribute.
> 
> That is totally different from internationalizing the internal kernel
> messages (which, btw, some people are working on...)  That I would not
> agree to as it's just too hard to keep up with and would be pointless in
> a way.
> 
> So I really do want to see a translated copy of the HOWTO,
> stable-api-nonsense.txt, and possibly a few other files in the main
> kernel tree (SubmittingPatches, CodingStyle, and SubmittingDrivers might
> all be good canidates for this.)  These files change relativly
> infrequently (the HOWTO file has had only 7 changes in 1 and 1/2 years,
> and they were very minor ones) and should be easy for the translators to
> keep up with.

But what is the point of having them in tree?

- regular review process does not work for them.

- regular release process does not work for them; translations want
release few days after -stable is released.

- kernel contributors will _not_ be able to fix them when they change
the original.

Plus, I'm not even sure if we have enough space. There are lots of
languages.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
