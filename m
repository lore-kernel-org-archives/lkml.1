Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYAXUIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYAXUIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbYAXUIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:08:01 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37228 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756908AbYAXUIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:08:00 -0500
Date: Thu, 24 Jan 2008 20:51:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Newall <davidn@davidnewall.com>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080124195133.GA2375@elf.ucw.cz>
References: <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com> <20080122160114.GB23277@does.not.exist> <4798C511.8070305@davidnewall.com> <20080124172414.GD4476@does.not.exist> <4798D10C.6090109@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4798D10C.6090109@davidnewall.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-01-25 04:25:24, David Newall wrote:
> Adrian Bunk wrote:
> > Removing dead code makes:
> > - the kernel smaller,
> > - the kernel faster and
> > - makes it easier to maintain the non-dead code.
> >   
> 
> The performance benefit is trivial, and the improvement to
> maintainability is even less.
> 
> > All of these are considered useful by the people who actually 
> > contribute to the Linux kernel.
> >   
> 
> Contributions to the kernel take forms other than just code.  I'm
> contributing in this very instance by putting the argument against
> removal of code.  Once removed it'll be much harder to re-insert than to
> repair in-situ.

/-------------------------\
|                         |
| Stop feeding the TROLL  |
|                         |
\-------------------------/
            ||
            ||
            ||
            ||
            ||
            ||
            ||
				(yes, that's you, David. You are
				wasting everyone's time. Go away.)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
