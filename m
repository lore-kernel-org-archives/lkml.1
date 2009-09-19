Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbZISKTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbZISKTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 06:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbZISKTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 06:19:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46669 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbZISKTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 06:19:08 -0400
Date: Sat, 19 Sep 2009 12:19:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>, jikos@suse.cz
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>
Subject: Re: [PATCH 7/7] w35und: Remove some write-only struct members
Message-ID: <20090919101901.GA518@elf.ucw.cz>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-4-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-6-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-7-git-send-email-penberg@cs.helsinki.fi> <20090812081550.GG23832@elf.ucw.cz> <84144f020908120121j542a895fw5f4cdda18890d417@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020908120121j542a895fw5f4cdda18890d417@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-08-12 11:21:53, Pekka Enberg wrote:
> Hi Pavel,
> 
> On Wed, Aug 12, 2009 at 11:15 AM, Pavel Machek<pavel@ucw.cz> wrote:
> > On Wed 2009-08-12 11:03:39, Pekka Enberg wrote:
> >> There's no point in keeping around struct members that are only written
> >> to but never read.
> >>
> >> Cc: Pavel Machek <pavel@ucw.cz>
> >> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> >
> > ACK, but... Note I no longer have access to the hardware. It is
> > probably collecting dust in czech suse labs somewhere.
> 
> OK, do you still want to be CC'd on the patches? I much appreciate the review!
> 
> Btw, is there someone at czech suse labs interested in testing w35und?
> I don't have the hardware either which leaves us with just one
> tester... :-)

Can we get some help? Kohjinsha seems to be one of the very few
machines with that hw...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
