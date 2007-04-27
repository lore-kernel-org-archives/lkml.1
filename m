Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbXD0OzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbXD0OzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbXD0OzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:55:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50698 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755942AbXD0OzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:55:13 -0400
Date: Fri, 27 Apr 2007 16:55:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070427145507.GP22250@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> <1177573348.5025.224.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> <20070426224005.GA21926@elf.ucw.cz> <84144f020704262241s5bcfc043k55f9d60e368b3c9e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020704262241s5bcfc043k55f9d60e368b3c9e@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-04-27 08:41:56, Pekka Enberg wrote:
> On 4/27/07, Pavel Machek <pavel@ucw.cz> wrote:
> >Now, it would be _very_ nice to be able to snapshot system and
> >continue running, but I just don't see how to do it without extensive
> >filesystem support.
> 
> So what kind of support do we need from the filesystem?

"forcedremount ro, not telling anyone, not killing processes" would do
the trick. FS snapshots might do.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
