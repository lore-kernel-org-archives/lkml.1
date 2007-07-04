Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbXGDVwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbXGDVwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXGDVwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:52:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58879 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755453AbXGDVwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:52:00 -0400
Date: Wed, 4 Jul 2007 23:47:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de
Subject: Re: blink driver power saving
Message-ID: <20070704214738.GA1685@elf.ucw.cz>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021351.57965.ak@suse.de> <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com> <200707021439.27357.ak@suse.de> <d120d5000707020642j752ca814l501aaa543f9babcf@mail.gmail.com> <d120d5000707020643y1b4f03ebid0ae37adb40d0a53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000707020643y1b4f03ebid0ae37adb40d0a53@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >I was thinking about something like the atached (untested and sorry
> >for using attachment). It shoudl blink just one led (numLock) on any
> >keyboard that has such LED (and allows to control it).
> >
> 
> Argh, bad one. This one shoudl be better.

Does it blink for you? It does not seem to do anything here :-(.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
