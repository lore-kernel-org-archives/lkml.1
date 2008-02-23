Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbYBWPZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbYBWPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759288AbYBWPZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:25:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4725 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758262AbYBWPZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:25:36 -0500
Date: Sat, 23 Feb 2008 16:25:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Newall <davidn@davidnewall.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080223152522.GA4287@ucw.cz>
References: <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain> <47BE0C12.604@garzik.org> <m3k5kxq2ih.fsf@maximus.localdomain> <20080222184518.GB6060@ucw.cz> <m3zlts393a.fsf@maximus.localdomain> <20080223094334.GA3081@elf.ucw.cz> <47C013E2.6040201@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C013E2.6040201@davidnewall.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-02-23 23:08:58, David Newall wrote:
> Pavel Machek wrote:
> > On Fri 2008-02-22 23:44:09, Krzysztof Halasa wrote:
> >   
> >> Pavel Machek <pavel@ucw.cz> writes:
> >>
> >>     
> >>> Zaurus is one example, second is small screen where you need big font
> >>> to keep it readable (x60 on desk).
> >>>       
> >> Come on, are you doing Linux kernel development on PDA?

Actually, I'd like to. There's a lot to fix on zaurus. Bit corruption
while sleeping is high on list, but I guess I should move out of
2.6.16, first.

> > I review patches on it, sometimes, yes.
> >   
> 
> Do you actually get 80 columns wide on it?

No, something like 62... but it is usually enough. x60 is about 100
columns wide (big font needed).

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
