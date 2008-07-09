Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbYGIU4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbYGIU4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbYGIUzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:55:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1539 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755679AbYGIUzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:55:45 -0400
Date: Wed, 9 Jul 2008 22:11:24 +0200
From: Pavel Machek <pavel@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: alphabetic ordering of MAINTAINERS
Message-ID: <20080709201123.GB11006@ucw.cz>
References: <20080704063455.GA13999@digi.com> <200807040852.27809.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807040852.27809.oliver@neukum.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri 2008-07-04 08:52:27, Oliver Neukum wrote:
> Am Freitag 04 Juli 2008 08:34:55 schrieb Uwe Kleine-König:
> > Hello,
> > 
> > I wanted to add an entry to MAINTAINERS and while doing it I saw that in
> > the corresponding region the alphabetic ordering is broken.  Then I
> > inteded to fix that up for a trivial patch.  Next was to check the rest
> > of the file and there are so much misorderings that it's not sensible to
> > choose the trivial path anymore as there are currently 114 entries out
> > of order[1].
> 
> What good does alphabetic ordering? You'll grep it anyway.

Actually alphabetic numberic sucks. It would be nice to group entries
by subsystem, so you have

networking

network drivers

wireless network drivers

iwl3945

...because sometimes grep is hard. Try greping for ALSA.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
