Return-Path: <linux-kernel-owner+w=401wt.eu-S933993AbXGZNIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbXGZNIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759649AbXGZNIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 09:08:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2752 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762053AbXGZNIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 09:08:12 -0400
Date: Wed, 25 Jul 2007 19:29:58 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] Cell SPE logos
Message-ID: <20070725192957.GC10208@ucw.cz>
References: <20070716135550.010775000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716135550.010775000@pademelon.sonytel.be>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The Cell Broadband Engine contains a 64-bit PowerPC core with 2 hardware
> threads (called PPEs) and 8 Synergistic Processing Engines (called SPEs).
> When booting Linux, 2 penguins logos are shown on the graphical console by
> the standard frame buffer console logo code.
> 
> To emphasize the existence of the SPEs (which can be used under Linux), we
> added a second row of (smaller) helper penguin logos, one for each SPE.

Does this belong in kernel?

It is kernel boot log, not random advertising place. Various splash
projects can get you any graphics you want...


						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
