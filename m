Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYDNKqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYDNKqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYDNKqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:46:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1446 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751876AbYDNKqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:46:38 -0400
Date: Mon, 14 Apr 2008 12:46:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: sound/usb/usbaudio.c: coding style
Message-ID: <20080414104626.GA4756@ucw.cz>
References: <20080329210927.GA12239@elf.ucw.cz> <s5hfxtohh7z.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hfxtohh7z.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon 2008-04-14 12:18:56, Takashi Iwai wrote:
> Hi,
> 
> just back from vacation and struggling with pending patches...
> 
> At Sat, 29 Mar 2008 22:09:28 +0100,
> Pavel Machek wrote:
> > 
> > 
> > Putting space between ! and variable is a strange coding style, fix
> > that, also make it fit into 80 columns where that is easy.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> Applied to ALSA tree now (with a fix for a coding issue you introduced
> ;).  Thanks.

Thanks!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
