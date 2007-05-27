Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbXE0VDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbXE0VDO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbXE0VC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:02:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4889 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756261AbXE0VC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:02:57 -0400
Date: Sun, 27 May 2007 21:02:37 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ray Lee <ray-lk@madrabbit.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070527210236.GF3989@ucw.cz>
References: <20070519223843.GN11115@waste.org> <20070520035259.GA13224@khazad-dum.debian.net> <20070521222339.GF11115@waste.org> <20070521230349.GA645@khazad-dum.debian.net> <20070522224515.GW11115@waste.org> <20070523001943.GA3743@khazad-dum.debian.net> <20070523014825.GX11115@waste.org> <20070523041958.GA15952@khazad-dum.debian.net> <2c0942db0705222141se133553re06370476d436b12@mail.gmail.com> <20070523125100.GA826@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523125100.GA826@khazad-dum.debian.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> I shouldn't have to upgrade my BIOS to work with a new kernel any more
> > >> than I should have to upgrade my browser.
> > >
> > >We don't agree there, as you are not talking about a stable kernel series.
> > 
> > Ah, so you're planning on submitting these patches for 2.7 then? 2.6
> > is perpetually stable. Matt is quite correct; feel free to ask for
> > clarifications from Linus et al if you need guidance.
> 
> 2.6.x.y is stable.  2.6.x is not by any reasonably strict definition of

Wrong. 2.6.x is stable as in 'must not break userspace, must not
regress'.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
