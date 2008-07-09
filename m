Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYGIU4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYGIU4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYGIUzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:55:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1525 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754914AbYGIUzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:55:37 -0400
Date: Wed, 9 Jul 2008 22:32:17 +0200
From: Pavel Machek <pavel@suse.cz>
To: Felipe Balbi <felipebalbi@users.sourceforge.net>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Battery life difference
Message-ID: <20080709203216.GF11006@ucw.cz>
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com> <20080705082352.4b6be669@infradead.org> <31e679430807050844r30ff74fby7e15641573b42d82@mail.gmail.com> <20080705085432.2f9b2964@infradead.org> <31e679430807051041w6dd9b917xc51f31f66fbd65d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31e679430807051041w6dd9b917xc51f31f66fbd65d3@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-07-05 20:41:07, Felipe Balbi wrote:
> Hi,
> 
> On Sat, Jul 5, 2008 at 6:54 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> > you may also need to toggle your bios to enable AHCI btw
> >
> >>
> >> > Also take a look at
> >> > http://kerneltrap.org/mailarchive/linux-kernel/2008/5/8/1771024
> >> > because these patches save like 0.75W in our lab.
> >>
> >> cool, is it merged upstream ?
> >> I'll build current git kernel and reply again with new linux results.
> >> It could be that ubuntu 2.6.24 is broken somehow...
> >>
> >> > To be honest, I'm surprised at your results; in our testing (with a
> >> > different distro though) we don't see such a difference and Linux is
> >> > doing rather well.
> >>
> >> can you get powertop results in a 2.6.24 distro kernel and current git
> >> kernel ?
> >
> > most of my measurement machines are in the office ;(
> >
> > Anyway, also make sure you use the 0.11 version of powertop; we added
> > some newer stuff into that version...
> 
> Cool, now I'm using current linux 2.6.26-rc8 from git
> b8a0b6ccf2ba2519ace65d782b41ee91bf3c3778
> 
> Now I'm reaching 9.8w consumption :-)

Cool... how low can Windows go?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
