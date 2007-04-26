Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbXDZX1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbXDZX1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbXDZX1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:27:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50862 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755210AbXDZX1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:27:34 -0400
Date: Fri, 27 Apr 2007 01:27:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Lang <david.lang@digitalinsight.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070426232724.GL21695@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> <1177573348.5025.224.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> <20070426224256.GB21926@elf.ucw.cz> <Pine.LNX.4.63.0704261520350.9674@qynat.qvtvafvgr.pbz> <20070426231228.GI21695@elf.ucw.cz> <Pine.LNX.4.63.0704261545100.9674@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0704261545100.9674@qynat.qvtvafvgr.pbz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >That's a feature. If you are booting from live CD, you _want_ to erase
> >any hibernation image.
> 
> why?
> 
> it's been stated that doing a std and booting another OS (including 
> windows) is a valid and common useage. saying that if you boot another OS 
> you trash your suspended image doesn't sound reasonable.

If you hibernate your machine, boot from live cd, and change anything
on any filesystem, you are pretty likely to loose that filesystem.

Doing that with Windows is okay as Windows do not usually write to
ext3 partitions.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
