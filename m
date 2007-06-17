Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbXFQOMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbXFQOMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 10:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbXFQOMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 10:12:03 -0400
Received: from barikada.upol.cz ([158.194.242.200]:39900 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbXFQOMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 10:12:01 -0400
Date: Sun, 17 Jun 2007 16:24:30 +0200
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] (Re: regression tracking (Re: Linux 2.6.21))
Message-ID: <20070617142430.GF16016@flower.upol.cz>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <6bffcb0e0706170322j3c51868fn6189bfd7d3bcac1@mail.gmail.com> <20070617114709.GD16016@flower.upol.cz> <200706171413.40890.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706171413.40890.rjw@sisk.pl>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 02:13:39PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 17 June 2007 13:47, Oleg Verych wrote:
[]
> > It's OK _only_ in case of unknown, hard to find *hardware* bugs.
> > 
> > If you think it's "a good thing" for bad, untested by developer
> > code, then something is completely wrong.
> 
> Oh, I've just fixed two purely software bugs pointed out by binary searching
> in the code that I'm sure has been tested, not only by its developers, but the
> bugs only showed up in my configuration (on one out of four test boxes).
> 
> There are so many different kernel configurations possible that there's no way
> a developer can test them all.

With current state of affairs it's not only hard for developers, but
and for users: <20070221220520.GA20659@artselect.com>,
              <20070429230037.95120@gmx.net>

I'm trying to re-do some kbuild stuff, but i'm getting rather offensive
answers :( <1182020654.8176.398.camel@chaos>

(Even if i'm academic with free Internet, i doubt i even tried to
think to improve something, if i didn't have one, because i wouldn't knew
huge lkml traffic, problems, etc.)

Maybe i'm wrong. But reducing amount of traffic/files and ease of
(re-)configuration are not last things to be done for better testing.
All for speed of getting and compiling kernel. Latter for avoiding
bugs and noise due to inconsistent build configuration.

Finally again, bug-reporting and tracking tools, i've tried to discuss
are major problems out there I think it's plain easy and deal with. One
more example:

    <handler.s.C.117647526113388.transcript@bugs.debian.org>
    Xref: news.gmane.org gmane.linux.debian.devel.kernel:28095
    <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/28095>
____
