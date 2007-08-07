Return-Path: <linux-kernel-owner+w=401wt.eu-S938140AbXHGWIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938140AbXHGWIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967051AbXHGVtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:49:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50114 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967246AbXHGVtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:49:51 -0400
Date: Tue, 7 Aug 2007 23:49:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: trenn@suse.de, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, vojtech@suse.cz
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070807214947.GB4413@elf.ucw.cz>
References: <46B1988C.3090302@t-online.de> <200708031459.07108.lenb@kernel.org> <20070806095504.GA1934@elf.ucw.cz> <200708071458.45687.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708071458.45687.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-08-07 14:58:45, Len Brown wrote:
> On Monday 06 August 2007 05:55, Pavel Machek wrote:
> > > For the
> > > upstream kernel, I think it is more appropriate to expose and fix
> > > the fundamental problems.  For distro kernels, I'm less concerned
> > > if you hide bugs instead of fixing them.
> > 
> > This is okay as long as you are willing to work around the fundamental
> > problems in kernel. You are unable to _fix_ them. They are broken
> > BIOSes.
> 
> The thing Linux needs to figure out is why Windows doesn't
> get confused by what Linux claims to be broken BIOS.

Why do you assume that Windows work? Yes, they probably will not have
'machine runs at 50% speed' problem, but I'd be very surprised if
critical shutdown  worked properly on more than 90% of notebooks....

> So far I have one live sighting to be addressed by
> the upstream kernel (from Knut).  I'm certainly looking
> forward to the 2nd live sighting...

Ok, I guess I should steal that old xe3 I was talking about...

Vojtech, could I have that machine from table football room for a few
experiments? I keep using it as counterexample.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
