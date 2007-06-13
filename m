Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbXFMUgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbXFMUgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbXFMUgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:36:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:59021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbXFMUg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:36:29 -0400
Date: Wed, 13 Jun 2007 13:37:37 -0700
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthias Schniedermeyer <ms@citd.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
Message-ID: <20070613203737.GB5708@suse.de>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de> <466C3B64.4070806@citd.de> <20070611060759.GB914@suse.de> <20070613141818.GF5986@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613141818.GF5986@ucw.cz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 02:18:18PM +0000, Pavel Machek wrote:
> Hi!
> 
> > Yes, but this file, and the stable-api-nonsense.txt files are there to
> > help people understand both the kernel's philosophy, as well as
> > encourage them to help contribute.
> > 
> > That is totally different from internationalizing the internal kernel
> > messages (which, btw, some people are working on...)  That I would not
> > agree to as it's just too hard to keep up with and would be pointless in
> > a way.
> > 
> > So I really do want to see a translated copy of the HOWTO,
> > stable-api-nonsense.txt, and possibly a few other files in the main
> > kernel tree (SubmittingPatches, CodingStyle, and SubmittingDrivers might
> > all be good canidates for this.)  These files change relativly
> > infrequently (the HOWTO file has had only 7 changes in 1 and 1/2 years,
> > and they were very minor ones) and should be easy for the translators to
> > keep up with.
> 
> But what is the point of having them in tree?

Wider exposure.  It will greatly increase the "google-juice" of it and
helps out when pointing people at the needed information.

> Plus, I'm not even sure if we have enough space. There are lots of
> languages.

"space"?  Since when are we running out of space?  The kernel is "only"
growing at 10% a year and is a mere 8.1 million lines or so.  We have
plenty of space on the mirrors to take up :)

thanks,

greg k-h
